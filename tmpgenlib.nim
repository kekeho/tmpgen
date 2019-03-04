import os

proc isDir(filepath: string): bool =
    let path_info: FileInfo = getFileInfo(filepath)
    if path_info.kind == pcDir:
        result = true
    else:
        result = false

proc fileCopy*(from_filenames: seq, to_dir: string): void =
    discard """Copy files from [from_filenames] to [to_dir]
    Args:
        from_filenames: string which includes regular expression
        to_dir: copy to [to_dir]
    """
    if not existsDir(to_dir):
        createDir(joinPath(to_dir))

    for from_filename in from_filenames:  ## copy each files
        let to_path: string = joinPath(to_dir, from_filename.splitPath.tail)
        if isDir(from_filename) == true:
            echo from_filename
            copyDirWithPermissions(from_filename, to_path)
        else:
            copyFileWithPermissions(from_filename, to_path)


proc copytest: void =
    # argc and argv
    let
        argc = paramCount()
        argv = commandLineParams()

    fileCopy(argv[0..argc-2], argv[argc-1])

if isMainModule:
    copytest()

