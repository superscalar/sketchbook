(* https://sandbox.bio/concepts/bwt *)

let explode s = List.init (String.length s) (String.get s);;
let implode l = String.of_seq (List.to_seq l);;

let rec appendLast car cdr =
  match cdr with
  | h :: t -> h :: appendLast car t
  | _ -> [car];;

let rotOne s =
  match explode s with
  | [] -> "" 
  | h :: t -> implode (appendLast h t);;

let rec rotN s n =
  match n with
  | 0 -> s
  | _ -> rotOne (rotN s (n - 1));;

let rec upto2 n =
  match n with
  | 0 -> [0] 
  | _ -> n :: upto2 (n - 1);;

(* List.rev does this too *)
let rec rev (l: 'a list) : 'a list = 
  match l with 
  | [] -> []
  | x::tl -> (rev tl) @ [x]
;;

let upto n = rev (upto2 n);;

let srcString = "big omega" ^ "$";; (* $ should be something not in the source string *)
let rotatedStrings = List.map (rotN srcString) (upto (String.length srcString - 1));;
let sortedRotated = List.sort compare rotatedStrings;;

let grabLast s = List.nth (explode s) ((String.length s) - 1);;
let bwt = implode (List.map grabLast sortedRotated );;

let () = print_string bwt;;
