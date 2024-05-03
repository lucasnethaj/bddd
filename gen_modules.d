#!/usr/bin/env rdmd

import std.array;
import std.getopt;
import std.path;
import std.file;
import std.stdio;
import std.format;
import std.algorithm;
import std.exception;

int main(string[] args) {
    try {
        return _main(args);
    }
    catch(Exception e) {
        stderr.writeln(e.message);
        return 1;
    }
}

int _main(string[] args) {
    immutable program = args[0];
    string[] include_paths;
    string[] ignore_patterns = ["unitdata", "package", "tests"];
    string out_file;

    auto main_args = getopt(args,
        "I", "include path", &include_paths,
        "ignore", format("ignore patterns, default: %s", ignore_patterns), &ignore_patterns,
        "o|output", "Output file", &out_file,
    );
    if (main_args.helpWanted) {
        defaultGetoptPrinter(
            [
            "Documentation: https://docs.tagion.org/",
            "",
            "Generate a module names from include_paths",
            "Usage:",
            format("%s [<option>...]", program),
            "",
            "<option>:",

        ].join("\n"),
        main_args.options);
        return 0;
    }

    enforce(!include_paths.empty, format("No include paths specified"));

    File fout;
    if(out_file.empty) {
        fout = stdout();
    }
    else {
        if(out_file.exists) {
            out_file.remove();
        }
        fout = File(out_file, "a");
    }

    string[] all_modules;

    foreach(path; include_paths) {
        enforce(path.isAbsolute, format("%s should be an absolute path", path));

        foreach(file; dirEntries(path, "*.d", SpanMode.depth)) {
            if(file.isFile && !ignore_patterns.any!(pattern => file.name.canFind(pattern))) {
                /* writeln(asRelativePath(file.name, path)); */
                all_modules ~= relativePath(file.name,path).stripExtension.replace(dirSeparator, ".");
                /* fout.writefln!"public import %s;"(relativePath(file.name,path).stripExtension.replace(dirSeparator, ".")); */
            }
        }
    }

    fout.writeln("module testbench.all_modules;");
    fout.writeln("import std.meta;");
    fout.writeln(all_modules.map!(m => "static import " ~ m ~ ";\n").joiner);
    fout.writeln("alias test_modules = AliasSeq!(");
    fout.writeln(all_modules.map!(m => m ~ ",\n").joiner);
    fout.writeln(");");

    return 0;
}
