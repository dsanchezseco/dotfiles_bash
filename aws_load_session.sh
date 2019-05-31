# config to set the aws credentials with the mfa in a painless way
# export AWS credentials for given profile
aws.load_credentials() {


  _unset() { unset AWS_PROFILE AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY ; }
  _hint() { echo && echo "[HINT] Use '-1' to unload current session" ; }

  # 'default' is not a profile we want to use
  local profiles more_profiles aws_access_key_id aws_secret_access_key chosen_profile
  profiles=$(grep -o '\[.*\]' ~/.aws/credentials | tr -d "][" )
  more_profiles=$(grep -o '\[.*\]' ~/.aws/config | tr -d "][" | cut -d' ' -f2)
  profiles="$(echo $profiles $more_profiles | tr ' ' '\n' | grep -v 'default' | sort -u | xargs)"
  chosen_profile=$1
  if [ -z "${chosen_profile}" ] ; then
    echo "You need to choose one AWS profile from this list:"  && echo "${profiles}"
    _hint
    return 1
  elif [ "${chosen_profile}" = "-1" ] ; then
    _unset
    echo "AWS information unloaded from session"
    return 0
  elif [ "${profiles}" = "${profiles//${chosen_profile}}" ] ; then
    echo "Profile '${chosen_profile}' not found. Valid profiles are:" && echo "${profiles}"
    _hint
    return 2
  fi

  _unset
  mfa_token=$2
  if [ -z "${mfa_token}" ] ; then
    echo "MFA token is missing, loading previous session..."
    _hint

    aws_access_key_id=$(aws configure get aws_access_key_id --profile ${chosen_profile})
    [ -z "${aws_access_key_id}" ] && \
      echo && echo "[ERROR] No credentials found, you need to authenticate again" && \
      return 3

    export AWS_PROFILE=${chosen_profile}
  else
    echo "Creating new temmporary session with MFA token..."
    cross_account_role=$(aws configure get x_role_arn --profile $chosen_profile)
    [ -z "${cross_account_role}" ] && \
      echo "[ERROR] you need to configure chosen role ARN as 'x_role_arn' in ~/.aws/config, under [profile ${chosen_profile}" && \
      return 4

    mfa_iam=$(aws configure get x_mfa_serial --profile $chosen_profile)
    [ -z "${cross_account_role}" ] && \
      echo "[ERROR] you need to configure your MFA ARN as 'x_mfa_arn' in ~/.aws/config, under [profile ${chosen_profile}" && \
      return 5

    temp_keys=($(aws sts assume-role --role-arn $cross_account_role --role-session-name session-$1 --serial-number $mfa_iam --token-code $mfa_token --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' --output text))
    [ $? -ne 0 ] && return -1

    export AWS_PROFILE=${chosen_profile}

    aws_access_key_id=${temp_keys[0]}
    export AWS_ACCESS_KEY_ID=${aws_access_key_id}
    aws configure set aws_access_key_id ${aws_access_key_id}

    aws_secret_access_key=${temp_keys[1]}
    export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}
    aws configure set aws_secret_access_key ${aws_secret_access_key}

    aws_session_token=${temp_keys[2]}
    export AWS_SESSION_TOKEN=${aws_session_token}
    aws configure set aws_session_token ${aws_session_token}
  fi
}
