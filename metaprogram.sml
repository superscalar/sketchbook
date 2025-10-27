open OS;
open Random;
open CommandLine;

val chars = List.map String.str (String.explode "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");;

fun makeTypeVariable Type name = Type ^ " " ^ name ^ ";";;
val makeDouble = makeTypeVariable "double";;
val makeInt = makeTypeVariable "int";;
val intx = makeInt "x";;

val seed: (int*int) = (128, 256);;
val myRand = rand seed;; (* the sosml interpreter has rand -> unit -> rand, but SMLNJ needs seed values *)
val charlen = length chars;;

fun makeVariableName 0 = ""
  | makeVariableName len = let
      val randomCharIndex = (floor ((randReal myRand) * (real charlen)))
      val randomChar = List.nth(chars, randomCharIndex)
    in
      randomChar ^ makeVariableName (len - 1)
  end;;

val randomVariable = makeDouble (makeVariableName 10);;

val programHeader = "#include <stdio.h>\n#include <stdlib.h>\nvoid f(int d) {\n";;
val programFooter = "\tprintf(\"%d\\n\", d);\n}\nint main(int argc, const char** argv) {\n\tint d = atoi(argv[1]);\n\tf(d);\n\treturn 0;\n}";;

val doubleSizeInBytes = 8; (* TODO: switch to a big struct *)
val megabyte = 1024 * 1024;
val nVariables = megabyte div doubleSizeInBytes;
val extra = 100;
val variablesToCreate = nVariables + extra;
fun makeNVariables 0 = ""
  | makeNVariables n = "\t" ^ makeDouble (makeVariableName 10) ^ "\n" ^ makeNVariables (n - 1);
  
fun makeNVariables2 0 = ""
  | makeNVariables2 n = let
		val () = print ";" in
	"\t" ^ makeDouble (makeVariableName 10) ^ "\n" ^ makeNVariables2 (n - 1) end;

open Int; (* opening Int overrides the global * to be * -> int -> int -> int *)
val args = CommandLine.arguments ();
val nvars_arg = Int.fromString ( List.nth(args, 0) );

(* val program = programHeader ^ (makeNVariables2 3000) ^ programFooter; *)
val program = case nvars_arg of
	NONE => "Please provide an integer as the first argument for the program"
	| SOME NVars => programHeader ^ (makeNVariables2 NVars) ^ programFooter; 
val () = print program;
OS.Process.exit(OS.Process.success);
