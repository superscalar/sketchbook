# Custom operators

## Raku

[Raku: Creating operators](https://docs.raku.org/language/optut)

```raku
sub prefix:<Σ>( *@number-list ) {
    [+] @number-list
}

say Σ (13, 16, 1); # OUTPUT: «30␤»

sub infix:<:=:>( $a is rw, $b is rw ) {
    ($a, $b) = ($b, $a)
}

sub postfix:<!>( Int $num where * >= 0 ) { [*] 1..$num }
say 0!;            # OUTPUT: «1␤»
say 5!;            # OUTPUT: «120␤»

sub postfix:<♥>( $a ) { say „I love $a!“ }
42♥;               # OUTPUT: «I love 42!␤»

sub postcircumfix:<⸨ ⸩>( Positional $a, Whatever ) {
    say $a[0], '…', $a[*-1]
}

[1,2,3,4]⸨*⸩;      # OUTPUT: «1…4␤»

constant term:<♥> = "♥"; # We don't want to quote "love", do we?
sub circumfix:<α ω>( $a ) {
    say „$a is the beginning and the end.“
};

α♥ω;               # OUTPUT: «♥ is the beginning and the end.␤»

```

## SML
```sml
infix <@>; fun (x <@> y) = x * y;
fun x <> y = x + y; (* <> is already != in SML, so I'm just redefining things here *)
infix <|??-=>; fun a <|??-=> b = a * b;
val z = 10 <@> 10;
val z2 = 10 <|??-=> 10;
```

## Haskell

## Scala

## Nim

```nim
proc `<|---|>`(x: int, y: int): int = x+y # weird operator
proc `<|?-?->`(x: int, y: int): int = x*y # fish operator
echo 100 <|?-?-> 100
```
