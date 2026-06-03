#!/usr/bin/env sh
set -eu

usage() {
  echo "Usage: $0 <env-file> <flutter-command> [args...]" >&2
  echo "Example: $0 env/.env.staging run" >&2
  echo "Example: $0 env/.env.prod build apk --release" >&2
}

if [ $# -lt 2 ]; then
  usage
  exit 64
fi

ENV_FILE="$1"
shift

if [ ! -f "$ENV_FILE" ]; then
  echo "Env file not found: $ENV_FILE" >&2
  exit 66
fi

while IFS= read -r raw_line || [ -n "$raw_line" ]; do
  line=$(printf '%s' "$raw_line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  case "$line" in
    ''|'#'*) continue ;;
  esac

  case "$line" in
    export\ *) line=${line#export } ;;
  esac

  case "$line" in
    *=*) ;;
    *)
      echo "Invalid env line in $ENV_FILE: $raw_line" >&2
      exit 65
      ;;
  esac

  key=${line%%=*}
  value=${line#*=}

  key=$(printf '%s' "$key" | sed 's/[[:space:]]//g')
  value=$(printf '%s' "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  case "$value" in
    \"*\") value=$(printf '%s' "$value" | sed 's/^"//;s/"$//') ;;
    \'*\') value=$(printf '%s' "$value" | sed "s/^'//;s/'$//") ;;
  esac

  if ! printf '%s' "$key" | grep -Eq '^[A-Za-z_][A-Za-z0-9_]*$'; then
    echo "Invalid env key in $ENV_FILE: $key" >&2
    exit 65
  fi

  set -- "$@" "--dart-define=$key=$value"
done < "$ENV_FILE"

exec flutter "$@"
