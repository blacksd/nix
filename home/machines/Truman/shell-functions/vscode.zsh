function code_open_workspace {
  pushd $HOME/Workspaces >/dev/null 2>&1
  _workspace=$(find *.code-workspace -type f -exec basename {} \; | fzf)
  if [ ! -z "${_workspace}" ]; then
    code ${_workspace}
  else
    echo "** No workspace selected"
  fi
  popd >/dev/null 2>&1
}
