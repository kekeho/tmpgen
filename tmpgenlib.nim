import os
import sequtils

let template_dir = joinPath(getHomeDir(), ".tmpgen/")  ## save templates to template_dir

proc isDir(filepath: string): bool =
    ## Check is [filepath] directory?
    ## Return:
    ##     true or false

    let path_info: FileInfo = getFileInfo(filepath)
    if path_info.kind == pcDir:
        result = true
    else:
        result = false


proc fileCopy(from_filenames: seq[string], to_dir: string): void =
    ## Copy files from [from_filenames] to [to_dir]
    ## Args:
    ##     from_filenames: string which includes regular expression
    ##     to_dir: copy to [to_dir]

    if not existsDir(to_dir):
        createDir(joinPath(to_dir))

    for from_filename in from_filenames:  ## copy each files
        let to_path: string = joinPath(to_dir, from_filename.splitPath.tail)
        if isDir(from_filename) == true:
            copyDirWithPermissions(from_filename, to_path)
        else:
            copyFileWithPermissions(from_filename, to_path)


proc initTemplateDir(label: string): void =
    ## Delete files in [label] dir

    let template_dir = joinPath(template_dir, label)
    removeDir(template_dir)


proc registTemplate*(files: seq[string], label: string): void =
    ## Regist files with label
    ## if already exist template, there will be deleted.
    ## Args:
    ##     files: filenames seq
    ##     label: template's label

    initTemplateDir(label)
    fileCopy(files, joinPath(template_dir, label))


proc addFilesToTemplate*(files: seq[string], label: string): void =
    ## Add files to template
    ## if not exist template which has [label], create new template.
    ## Args:
    ##     files: filenames seq
    ##     label: template's label

    fileCopy(files, joinPath(template_dir, label))


proc generate*(label: string, dir: string, pick_filenames: seq[string] = @[]): void =
    ## Generate files from template
    if pick_filenames.len > 0:
        var pick_filenames = pick_filenames
        # normalization filenames
        for index, filename in pick_filenames:
            pick_filenames[index] = joinPath(joinPath(template_dir, label), filename)
        
        fileCopy(pick_filenames, dir)
    else:
        let dir_name: string = joinPath(template_dir, label)
        let dir_files: seq[string] = toSeq(walkPattern(dir_name.joinPath("/*")))
        fileCopy(dir_files, dir)


proc test: void =
    # argc and argv

    let
        argc = paramCount()
        argv = commandLineParams()

    # registTemplate(argv[0..argc-2], argv[argc-1])
    if argc > 2:
        
        generate(argv[0], argv[1], argv[2..argc-1])
    else:
        generate(argv[0], argv[1])

if isMainModule:
    test()

