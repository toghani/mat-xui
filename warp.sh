#!/bin/bash


AUTH="MAT"
VER="1.0.0"

rd="\e[31m\e[01m"
blu="\e[36m\e[01m"
grn="\e[32m\e[01m"
ylw="\e[33m\e[01m"
bYlw="\e[1;33m"
pln="\e[0m"


CAN_TPUT=$(command -v tput >/dev/null 2>&1 && echo "true" || echo "false")
USE_DEF="false"
FORC="false"
SPIN_LEN=0
SPIN_ID=
WP_INS_PORT="40100"
WP_LIST_PORT=


STEP_STAT=1
WP_STAT=0

OS_S=
OS_IND=
REL=("Debian" "Ubuntu" "CentOS" "CentOS" "Alpine" "Arch")
REL_REGEX=("debian" "ubuntu" "centos|rd hat|kernel|oracle linux|alma|rocky" "amazon linux" "alpine" "arch linux")
PKG_UPD=("apt -y update" "apt -y update" "yum -y update" "yum -y update" "apk update -f" "pacman -Sy")
PKG_INS=("apt -y --fix-broken install" "apt -y --fix-broken install" "yum -y install" "yum -y install" "apk add -f --no-cache" "pacman -S --noconfirm")

declare -A TRANS
TRANS[000]="Option requires an argument:"
TRANS[001]="Invalid option:"
TRANS[002]="Invalid choice."
TRANS[003]=""
TRANS[004]=""
TRANS[005]="[INFO]"
TRANS[006]="[ALERT]"
TRANS[007]="[ERROR]"
TRANS[008]="[DEBUG]"
TRANS[009]="[WARNING]"
TRANS[011]="Version:"
TRANS[012]="Author:"
TRANS[013]=""
TRANS[014]="Options:"
TRANS[015]="Accept default values."
TRANS[016]="Force reinstall Warp Socks5 Proxy (WireProxy)."
TRANS[017]=""
TRANS[018]=""
TRANS[019]=""
TRANS[020]="Useful Commands:"
TRANS[021]="Uninstall Warp"
TRANS[022]="Change Warp Account Type (free, plus, ...)"
TRANS[023]="Turn on/off WireProxy"
TRANS[024]=""
TRANS[025]=""
TRANS[026]=""
TRANS[027]=""
TRANS[028]=""
TRANS[029]=""
TRANS[030]=""
TRANS[031]=""
TRANS[032]=""
TRANS[033]=""
TRANS[034]=""
TRANS[035]=""
TRANS[036]=""
TRANS[037]=""
TRANS[038]=""
TRANS[039]=""
# show_warnings
TRANS[040]="You're using this options:"
TRANS[041]="Accepting default values"
TRANS[042]="Forcing reinstall Warp Socks5 Proxy (WireProxy)"
TRANS[043]=""
TRANS[044]=""
TRANS[045]=""
TRANS[046]=""
TRANS[047]=""
TRANS[048]=""
TRANS[049]=""
# prompts
TRANS[050]="Default"
TRANS[051]="Exceeded maximum attempts. Exiting..."
TRANS[052]="Remaining attempts:"
TRANS[053]="Last attempt! Remaining attempt:"
TRANS[054]="Please enter a port for"
TRANS[055]="Oops! Invalid input. Please enter a port between 1 and 65535."
TRANS[056]="Oops! The port is already in use. Please choose another port between 1 and 65535!"
TRANS[057]="WireProxy"
TRANS[058]=""
TRANS[059]=""
# check_root
TRANS[060]="Verifying root access..."
TRANS[061]="Please run this script as root!"
TRANS[062]="Great News! You have Superuser privileges. Let's continue..."
# check_os
TRANS[063]="Verifying if your OS is supported..."
TRANS[064]="Unfortunately, your OS is not supported at this time! \n  The script supports Debian, Ubuntu, CentOS, Arch or Alpine systems only.\n"
TRANS[065]="Your os is compatible with this installation. Moving forward..."
# install_base_packages
TRANS[066]="Installing essential packages for your OS..."
TRANS[067]="There was an error during the installation of essential packages! \n  Please check your connection or try again later."
TRANS[068]="All required packages have been successfully installed."
# warp_command
TRANS[069]="Checking if [warp] command shortcut exists, and creating it if necessary..."
TRANS[070]="Failed to create [warp] command shortcut! Please try again later."
TRANS[071]="[warp] command shortcut created successfully."
TRANS[072]="[warp] command shortcut is already set up."
# warp_status
TRANS[073]="Checking WARP Status..."
TRANS[074]="The WARP socks5 proxy (WireProxy) is already installed and currently running. \n  WARP is listening on socks5://127.0.0.1:"
TRANS[075]="The WARP socks5 proxy (WireProxy) has already been installed, but it's currently not running."
TRANS[076]="The WARP socks5 proxy (WireProxy) isn't installed yet. No worries, we'll take care of it."
# install_warp
TRANS[077]="Installing WARP socks5 proxy (WireProxy)..."
TRANS[078]="Sorry, the installation of WARP socks5 proxy (WireProxy) failed! Please try again later."
TRANS[079]="You're all set! WARP socks5 proxy (WireProxy) has been installed and is ready to use. \n  WARP is listening on socks5://127.0.0.1:"
# start_warp
TRANS[080]="Activating the WARP socks5 proxy (WireProxy)..."
TRANS[081]="The WARP socks5 proxy (WireProxy) failed to start! Please try again later."
TRANS[082]="The WARP socks5 proxy (WireProxy) is active and listening on socks5://127.0.0.1:"
# confirm reinstall_warp
TRANS[083]="Do you want to proceed with reinstalling the WARP socks5 proxy?"
# reinstall_warp
TRANS[084]="Performing a fresh installation of WARP socks5 proxy (WireProxy)..."
TRANS[085]="Sorry, the reinstallation of WARP socks5 proxy (WireProxy) failed! Please try again later."
TRANS[086]="Completed! WARP socks5 proxy (WireProxy) has been reinstalled and is ready to use. \n  WARP is listening on socks5://127.0.0.1:"
TRANS[087]=""
TRANS[088]=""
TRANS[089]=""
TRANS[090]=""
TRANS[091]=""
TRANS[092]=""
TRANS[093]=""
TRANS[094]=""
TRANS[095]=""
TRANS[096]=""
TRANS[097]=""
TRANS[098]=""
TRANS[099]=""
TRANS[100]=""


# ===============================
# ******** Base Function ********
# ===============================
# Get Options
while getopts ":yf" opt; do
  case ${opt} in
    f)
      FORC="true"
      ;;
    y)
      USE_DEF="true"
      ;;
    :)
      echo -e "  ${rd}${TRANS[000]} -${OPTARG}${pln}" 1>&2
      exit 1
      ;;
    \?)
      echo -e "  ${rd}${TRANS[001]} -${OPTARG}${pln}" 1>&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))


function escaped_length() {
  # escape color from string
  local str="${1}"
  local stripped_len=$(echo -e "${str}" | sed 's|\x1B\[[0-9;]\{1,\}[A-Za-z]||g' | tr '\n' ' ' | wc -m)
  echo ${stripped_len}
}


function draw_line() {
  local line=""
  local width=$(( ${COLUMNS:-${CAN_TPUT:+$(tput cols)}:-92} ))
  line=$(printf "%*s" "${width}" | tr ' ' '_')
  echo "${line}"
}


function confirm() {
  local question="${1}"
  local options="${2:-Y/n}"
  local RESPONSE=""
  read -rep "  > ${question} [${options}] " RESPONSE
  RESPONSE=$(echo "${RESPONSE}" | tr '[:upper:]' '[:lower:]') || return
  if [[ -z "${RESPONSE}" ]]; then
    case "${options}" in
      "Y/n") RESPONSE="y";;
      "y/N") RESPONSE="n";;
    esac
  fi
  # return (yes=0) (no=1)
  case "${RESPONSE}" in
    "y"|"yes") return 0;;
    "n"|"no") return 1;;
    *)
      echo -e "${rd}${TRANS[002]}${pln}"
      confirm "${question}" "${options}"
      ;;
  esac
}


function run_step() {
  {
    $@
  } &> /dev/null
}


# Spinner Function
function start_spin() {
  local spin_chars='/-\|'
  local sc=0
  local delay=0.1
  local text="${1}"
  SPIN_LEN=$(escaped_length "${text}")
  # Hide cursor
  [[ "${CAN_TPUT}" == "true" ]] && tput civis
  while true; do
    printf "\r  [%s] ${text}"  "${spin_chars:sc++:1}"
    sleep ${delay}
    ((sc==${#spin_chars})) && sc=0
  done &
  SPIN_ID=$!
  # Show cursor
  [[ "${CAN_TPUT}" == "true" ]] && tput cnorm
}


function kill_spin() {
  kill "${SPIN_ID}"
  wait "${SPIN_ID}" 2>/dev/null
}


function end_spin() {
  local text="${1}"
  local text_len=$(escaped_length "${text}")
  run_step "kill_spin"
  if [[ ! -z "${text}" ]]; then
    printf "\r  ${text}"
    # Due to the preceding space in the text, we append '6' to the total length.
    printf "%*s\n" $((${SPIN_LEN} - ${text_len} + 6)) ""
  fi
  # Reset Status
  STEP_STAT=1
}


# Clean up if script terminated.
function clean_up() {
  # Show cursor && Kill spinner
  [[ "${CAN_TPUT}" == "true" ]] && tput cnorm
  end_spin ""
}
trap clean_up EXIT TERM SIGHUP SIGTERM SIGKILL


# Check OS Function
function get_os_release() {
  local RELEASE_OS=
  local RELEASE_CMD=(
    "$(grep -i pretty_name /etc/os-release 2>/dev/null | cut -d \" -f2)"
    "$(hostnamectl 2>/dev/null | grep -i system | cut -d : -f2)"
    "$(lsb_release -sd 2>/dev/null)"
    "$(grep -i description /etc/lsb-release 2>/dev/null | cut -d \" -f2)"
    "$(grep . /etc/redhat-release 2>/dev/null)"
    "$(grep . /etc/issue 2>/dev/null | cut -d \\ -f1 | sed '/^[ ]*$/d')"
  )

  for i in "${RELEASE_CMD[@]}"; do
    RELEASE_OS="${i}" && [[ -n "${RELEASE_OS}" ]] && break
  done

  echo "${RELEASE_OS}"
}


# Prompt Function
function prompt_port() {
  local for_text="${1}"
  local var_text="${2}"
  local attempts="${3:-0}"
  local check_occupied="${4:-false}"
  local default_port=""
  local error_msg=""

  # set defaults
  eval "default_port=\"\$${var_text}\""
  local ports_str="${default_port}"

  # remaining attempts
  local current_attempt=1
  local remaining_attempts=$((attempts - current_attempt + 1))
  local remaining_msg=""

  # array commands to check port occupation
  local check_cmds=(
    "ss:-nltp | grep -q"
    "lsof:-i"
  )

  # loop to get a correct port
  while true; do
    # reset error msg
    error_msg=""

    # calculate remaining attempts to show user
    remaining_attempts=$((attempts - current_attempt + 1))
    if [[ $remaining_attempts -gt 1 ]]; then
      remaining_msg="(${TRANS[052]} ${remaining_attempts})"
    else
      remaining_msg="(${TRANS[053]} ${remaining_attempts})"
    fi

    # ask user for input
    read -rep "  ${TRANS[054]} ${for_text} (1-65535): `echo $'\n  > '` ${for_text} [${TRANS[050]} '${default_port}'] ${remaining_msg}: " ports_str

    # Set default if input is empty
    if [[ -z "$ports_str" ]]; then
      ports_str=${default_port}
    fi

    # Check if port is a valid number between 1 and 65535
    is_invalid="false"
    if [[ ! "${ports_str}" =~ ^[0-9]+$ || ${ports_str} -lt 1 || ${ports_str} -gt 65535 ]]; then
      is_invalid="true"
      error_msg="${TRANS[055]}"
    fi

    # Check if port is occupied
    if [[ "${check_occupied}" == "true" ]]; then
      for cmd_arg in "${check_cmds[@]}"; do
        IFS=':' read -r cmd args <<< "${cmd_arg}"
        if command -v "${cmd}" &> /dev/null; then
          if eval "${cmd} ${args} \":${ports_str}\"" &> /dev/null; then
            is_invalid="true"
            error_msg="${TRANS[056]}"
            break
          fi
        fi
      done
    fi

    # if port is valid, set value and then break the loop
    if [[ "${is_invalid}" == "false" ]]; then
      eval "${var_text}=\$ports_str"
      break
    fi

    # check attempts
    if [[ ${attempts} -gt 0 && ${current_attempt} -ge ${attempts} ]]; then
      echo -e "  ${rd}${TRANS[051]}${pln}" 1>&2
      exit 1
    fi
    current_attempt=$((current_attempt + 1))

    # if invalid, show error
    echo -e "  ${rd}${error_msg}${pln}"
  done
}


# ===============================
# ********** BaseSteps **********
# ===============================
function step_check_os() {
  for ((OS_IND=0; OS_IND<${#REL_REGEX[@]}; OS_IND++)); do
    [[ $(get_os_release | tr '[:upper:]' '[:lower:]') =~ ${REL_REGEX[OS_IND]} ]] \
    && export OS_S="${REL[OS_IND]}" \
    && [ -n "${OS_S}" ] && break
  done
}


function step_install_pkgs() {
  {
    case "${OS_S}" in
      "Arch")
        ${PKG_UPD[OS_IND]}
        ;;
      *)
        ${PKG_UPD[OS_IND]}
        ${PKG_INS[OS_IND]} wget net-tools
        ;;
    esac
  }
  [[ $? -ne 0 ]] && STEP_STAT=0
}


function step_create_command() {
  {
    mkdir -p /etc/wireguard
    wget -N -P /etc/wireguard https://raw.githubusercontent.com/fscarmen/warp/main/menu.sh
    chmod +x /etc/wireguard/menu.sh
    ln -sf /etc/wireguard/menu.sh /usr/bin/warp
  }
  [[ $? -ne 0 ]] && STEP_STAT=0
}


function step_check_status() {
  WP_STAT=0
  if [[ $(type -p wireproxy) ]]; then
    WP_STAT=1
    if [[ $(ss -nltp) =~ wireproxy ]]; then
      WP_STAT=2
      WP_LIST_PORT=$(ss -nltp | grep 'wireproxy' | awk '{print $(NF-2)}' | cut -d: -f2)
    fi
  fi
}


function step_install_warp() {
  warp w <<< $'1\n1\n'"${WP_INS_PORT}"$'\n1\n'
  [[ $? -ne 0 ]] && STEP_STAT=0 || STEP_STAT=1
}


function step_start_warp() {
  systemctl start wireproxy
  sleep 2
}


function step_reinstall_warp() {
  {
    warp u <<< $'y\n'
    run_step "step_create_command"
    warp w <<< $'1\n1\n'"${WP_INS_PORT}"$'\n1\n'
  }
  [[ $? -ne 0 ]] && STEP_STAT=0 || STEP_STAT=1
}


# ===============================
# ************ Steps ************
# ===============================
function intro() {
  echo -e "${blu}
$(draw_line)
$(draw_line)
${pln}
  ${grn}${TRANS[011]}${pln} ${bYlw}${VER}${pln}
  ${grn}${TRANS[012]}${pln} ${bYlw}${AUTH}${pln}

  ${blu}${TRANS[010]}${pln}

  ${rd}${TRANS[014]}${pln}
    ${grn}-y${pln}     => ${bYlw}${TRANS[015]}${pln}
    ${grn}-f${pln}     => ${bYlw}${TRANS[016]}${pln}

  ${rd}${TRANS[020]}${pln}
    ${grn}warp u${pln} => ${bYlw}${TRANS[021]}${pln}
    ${grn}warp a${pln} => ${bYlw}${TRANS[022]}${pln}
    ${grn}warp y${pln} => ${bYlw}${TRANS[023]}${pln}
${blu}
$(draw_line)
$(draw_line)
${pln}"
}


function show_warnings() {
  local should_show="false"
  local alert_msgs=()
  local alert_vars=(
    "USE_DEF:-y:TRANS[041]"
    "FORC:-f:TRANS[042]"
  )

  # loop through options variables and check if they exist, add to final message
  for alert in "${alert_vars[@]}"; do
    IFS=':' read -r var option message <<< "${alert}"
    if [[ "${!var}" == "true" ]]; then
      should_show="true"
      alert_msgs+=("    ${rd}${option}${pln}   =>   ${blu}${!message}${pln}")
    fi
  done

  # if there is any message to show, echo it
  if [[ "${should_show}" == "true" ]]; then
    echo -e "  ${ylw}${TRANS[006]} ${TRANS[040]}${pln}"
    for msg in "${alert_msgs[@]}"; do
      echo -e "${msg}"
    done
    echo ""
  fi
}


function check_root() {
  start_spin "${ylw}${TRANS[060]}${pln}"
  [[ $EUID -ne 0 ]] && end_spin "${rd}${TRANS[007]} ${TRANS[061]}${pln}" && exit 1
  end_spin "${grn}${TRANS[062]}${pln}"
}


function check_os() {
  start_spin "${ylw}${TRANS[063]}${pln}"
  run_step "step_check_os"
  if [[ -z "${OS_S}" ]]; then
    end_spin "${rd}${TRANS[007]} ${TRANS[064]}${pln}" && exit 1
  fi
  if echo "${OS_S}" | grep -qiE "debian|ubuntu"; then
    export DEBIAN_FRONTEND="noninteractive"
  fi
  end_spin "${grn}${TRANS[065]}${pln}"
}


function prompt_all() {
  local attempts=5
  local check_occupied=$( [[ "${WP_STAT}" == "0" ]] && echo "true" || echo "false" )
  [[ "${USE_DEF}" == "false" ]] && prompt_port "${TRANS[057]}" "WP_INS_PORT" "${attempts}" "${check_occupied}"
}


function install_base_packages() {
  start_spin "${ylw}${TRANS[066]}${pln}"
  run_step "step_install_pkgs"
  if [[ "${STEP_STAT}" -eq 0 ]]; then
    end_spin "${rd}${TRANS[007]} ${TRANS[067]}${pln}" && exit 1
  fi
  end_spin "${grn}${TRANS[068]}${pln}"
}


function warp_command() {
  start_spin "${ylw}${TRANS[069]}${pln}"
  if ! command -v warp &> /dev/null; then
    run_step "step_create_command"
    if [[ "${STEP_STAT}" -eq 0 ]]; then
      end_spin "${rd}${TRANS[007]} ${TRANS[070]}${pln}" && exit 1
    fi
    end_spin "${grn}${TRANS[071]}${pln}"
  else
    end_spin "${grn}${TRANS[072]}${pln}"
  fi
}


function warp_status() {
  start_spin "${ylw}${TRANS[073]}${pln}"
  run_step "step_check_status"
  case "${WP_STAT}" in
    2)
      end_spin "${grn}${TRANS[074]}${WP_LIST_PORT}${pln}"
      ;;
    1)
      end_spin "${ylw}${TRANS[075]}${pln}"
      ;;
    0)
      end_spin "${ylw}${TRANS[076]}${pln}"
      ;;
  esac
}


function install_warp() {
  start_spin "${ylw}${TRANS[077]}${pln}"
  run_step "step_install_warp"
  run_step "step_check_status"
  if [[ "${STEP_STAT}" -eq 0 ]]; then
    end_spin "${rd}${TRANS[007]} ${TRANS[078]}${pln}" && exit 1
  fi
  end_spin "${grn}${TRANS[079]}${WP_LIST_PORT}${pln}\n"
}


function start_warp() {
  start_spin "${ylw}${TRANS[080]}${pln}"
  run_step "step_start_warp"
  run_step "step_check_status"
  if [[ "${WP_STAT}" -ne 2 ]]; then
    end_spin "${rd}${TRANS[007]} ${TRANS[081]}${pln}" && exit 1
  fi
  end_spin "${grn}${TRANS[082]}${WP_LIST_PORT}${pln}\n"
}


function reinstall_warp() {
  start_spin "${ylw}${TRANS[084]}${pln}"
  run_step "step_reinstall_warp"
  run_step "step_check_status"
  if [[ "${STEP_STAT}" -eq 0 ]]; then
    end_spin "${rd}${TRANS[007]} ${TRANS[085]}${pln}" && exit 1
  fi
  end_spin "${grn}${TRANS[086]}${WP_LIST_PORT}${pln}\n"
}


# ===============================
# ************* Run *************
# ===============================
clear
intro
show_warnings
check_root
check_os
install_base_packages
warp_command
warp_status
case "${WP_STAT}" in
  0)
    prompt_all
    install_warp
    ;;
  1|2)
    [[ "${FORC}" == "false" ]] && ! confirm "${TRANS[083]}" "y/N" && exit 0
    prompt_all
    reinstall_warp
    run_step "step_check_status"
    [[ "${WP_STAT}" -eq 1 ]] && start_warp
    ;;
esac


# END
clean_up
# END
