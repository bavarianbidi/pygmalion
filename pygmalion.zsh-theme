# Yay! High voltage and arrows!

prompt_seperator='%{$fg[magenta]%} | %{$reset_color%}'

prompt_setup_pygmalion(){
  ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
  ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}⚡%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_CLEAN=""

  base_prompt='%{$fg[cyan]%}%0~%{$reset_color%}'
  post_prompt='%{$fg[cyan]%}⇒%{$reset_color%}  '

  precmd_functions+=(prompt_pygmalion_precmd)
}

prompt_pygmalion_precmd(){
  local gitinfo=$(git_prompt_info)
  local gitinfo_nocolor=$(echo "$gitinfo" | perl -pe "s/%\{[^}]+\}//g")
  local exp_nocolor="$(print -P \"$base_prompt_nocolor$gitinfo_nocolor$post_prompt_nocolor\")"
  local prompt_length=${#exp_nocolor}
  
  local k8s=$(check_k8s)

  local nl=$'\n%{\r%}';
  PROMPT="$base_prompt$prompt_seperator$k8s$prompt_seperator$gitinfo$nl$post_prompt"
  RPROMPT='$(check_last_exit_code)'
}

check_last_exit_code() {
  local LAST_EXIT_CODE=$?
  if [[ $LAST_EXIT_CODE -ne 0 ]]; then
    local EXIT_CODE_PROMPT=' '
    EXIT_CODE_PROMPT+="%{$fg_bold[red]%} :-( %{$reset_color%}"
    echo "$EXIT_CODE_PROMPT"
  elif [[ $LAST_EXIT_CODE -eq 0 ]]; then
    local EXIT_CODE_PROMPT=' '
    EXIT_CODE_PROMPT+="%{$fg_bold[green]%} :-) %{$reset_color%}"
    echo "$EXIT_CODE_PROMPT"
  fi
}

check_k8s() {
  CURRENT_CONTEXT=$(kubectl config current-context)
  CURRENT_NAMESPACE=$(kubectl config view -o jsonpath="{.contexts[?(@.name==\"$CURRENT_CONTEXT\")].context.namespace}")
  if [ -z "$CURRENT_NAMESPACE" ];
  then
     CURRENT_NAMESPACE="default"
  fi  
  echo "%{$fg[blue]%}\u2638%{$reset_color%} %{$fg[red]%}$CURRENT_CONTEXT%{$reset_color%} %{$fg[yellow]%}( $CURRENT_NAMESPACE )%{$reset_color%}" # ☸
}


prompt_setup_pygmalion


