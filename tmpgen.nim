import argparse
import tmpgenlib
import strutils

const VERSION = "1.0"
const AUTHOR = "Hiroki Takemura"
const AUTHOR_EMAIL = "hirodora@me.com"
const AUTHOR_TWITTER = "@k3k3h0"
const PROJECT_URL = "https://github.com/kekeho/tmpgen"


let arg_parser = newParser("tmpgen"):  ## argument parser
    command("gen"):
        help("Generate template files in dir")
        arg("label")
        option("-d", "--dir", default=".")
        arg("collectfiles", nargs = -1, help="default: all")
        run:
            generate(opts.label, dir=opts.dir, pick_filenames=opts.collectfiles)

    command("regist"):
        help("""Create template with selected files.
if already have same label template, it will be deleted.
""")
        arg("label")
        arg("files", nargs = -1)
        run:
            registTemplate(opts.files, label=opts.label)
    
    command("add"):
        help("""Add files to template""")
        arg("label")
        arg("files", nargs = -1)
        run:
            addFilesToTemplate(opts.files, label=opts.label)
    
    command("info"):
        help("""Show version and info""")
        run:
            echo """tmpgen - The Template Generator -
version: $version
by $author
email: $email
twitter: $tw

template save dir: $savedir

See: $url""" % ["version", VERSION, "author", AUTHOR, "tw", AUTHOR_TWITTER,
                "email", AUTHOR_EMAIL, "url", PROJECT_URL, "savedir", template_dir]

proc main() =
    # argc and argv
    let
        argc = paramCount()
        argv = commandLineParams()
    
    arg_parser.run(argv)


if isMainModule:
    main()

