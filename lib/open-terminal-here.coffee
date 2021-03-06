exec = require("child_process").exec
path = require('path')

module.exports =

  configDefaults: {
    app: 'Terminal.app'
    args: ''
    win32App: 'cmd'
    win32Args: ''
  },

  activate: ->
    atom.workspaceView.command "open-terminal-here:open", => @open()

  open: ->
    isDarwin = document.body.classList.contains("platform-darwin")
    isWin32 = document.body.classList.contains("platform-win32")

    selectedView = atom.workspaceView.find('.tree-view .selected').views()?[0][0]
    isDir = selectedView?.hasClass("directory")
    isFile = selectedView?.hasClass("file")
    thepath = selectedView?.getPath()
    dirpath = if isFile then path.dirname thepath else thepath

    return if not dirpath

    if isDarwin
      @openDarwin dirpath
    else #isWin32
      @openWin32 dirpath

  openDarwin: (dirpath) ->
    app = atom.config.get('open-terminal-here.app')
    args = atom.config.get('open-terminal-here.args')
    exec "open -a #{app} #{args} #{dirpath}"

  openWin32: (dirpath) ->
    app = atom.config.get('open-terminal-here.win32App')
    args = atom.config.get('open-terminal-here.win32Args')
    exec "start /D #{dirpath} #{app} #{args}"
