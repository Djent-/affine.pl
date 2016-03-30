# [Redacted] 2016.02.14
# 2016.02.14 8:27 AM created
# 2016.02.14 9:49 AM submitted

use strict;
use warnings;

my @ord_lookup = ('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z');

# Returns integer 0 through 25 corresponding to input character
sub ordinal {
	my $char = shift;
	my $num = 0;
	foreach my $check (@ord_lookup) {
		return $num if $char eq $check;
		$num++;
	}
	die("Character out of bounds: $char\n");
}

# Returns an array of ordinals 0 through 25 given a string of characters a through z
sub ordinal_array {
	my $text = shift;
	my $textlength = length($text);
	my @ret;
	for (0 .. $textlength - 1) {
		push(@ret, ordinal(substr($text, $_, 1)));
	}
	return @ret;
}

# Returns a one-character string 'a' through 'z' corresponding to input number
sub char {
	my $ord = shift;
	return $ord_lookup[$ord] || die("Ordinal index out of bounds: $ord\n");
}

# Returns a string of characters a through z given an array of ordinals 0 through 25
sub char_string {
	my @ords = @_; # list flattening
	my $ret = "";
	for (@ords) {
		my $ch = char($_);
		$ret = "$ret$ch";
	}
	return $ret;
}

# Returns the multiplicative inverse of the given number (with 26)
sub mult_inverse {
	my $a = shift;
	for (0 .. 25) {
		return $_ if ($a * $_) % 26 eq 1;
	}
}

# Encryption function
sub affine_enc {
	my $a = shift;
	my $b = shift;
	my $plaintext = shift;
	my @plaintext = ordinal_array($plaintext);
	my @ciphertext;
	# y = ax + b mod 26
	# This would be a good use of the map function
	for (@plaintext) {
		push(@ciphertext, (($a * $_) + $b) % 26);
	}
	return char_string(@ciphertext);
}

# Decryption function
sub affine_dec {
	my $a = shift;
	my $b = shift;
	my $ciphertext = shift;
	my @ciphertext = ordinal_array($ciphertext);
	my @plaintext;
	# x = a' * (y - b) mod 26
	# This would be a good use of the map function
	$a = mult_inverse($a);
	for (@ciphertext) {
		push(@plaintext, ($a * ($_ - $b)) % 26);
	}
	return char_string(@plaintext);
}

# Main brute-force function
sub brute {
	my @possible_a = (1,3,5,7,9,11,15,17,19,21,23,25);
	my $ciphertext = affine_enc(1,5,"perlisbeautiful");
	foreach my $a (@possible_a) {
		foreach my $b (1..26) {
			print("Encryption key: a = $a, b = $b\n");
			print("Decryption equation: x = " . mult_inverse($a) . " * (y - $b)\n\n");
			print("Plaintext:\n" . affine_dec($a, $b, $ciphertext) . "\n\n");
			print("Hit enter to continue search or 'S' key to stop: ");
			my $input = <STDIN>;
			chomp($input);
			if ($input eq "S") {
				print("The plain text message below was encrypted with a = $a, b = $b\n");
				print(affine_dec($a, $b, $ciphertext));
				return;
			}
		}
	}
}
brute();

# Tests
sub ordinal_test {
	print("Ordinal 'a':\t" . ordinal("a") . "\n");
	print("Ordinal 'b':\t" . ordinal("b") . "\n");
}
#ordinal_test();
sub char_test {
	print("Character 2:\t" . char(2) . "\n");
}
#char_test();
sub ordinal_array_test {
	my @arr = ordinal_array('abcdef');
	print("Ordinal 'abcdef':\t@arr\n");
}
#ordinal_array_test();
sub char_string_test {
	my @ords = (8,7,6,5,4,3,2,1);
	print("Characters 8,7,6,5,4,3,2,1:\t" . char_string(@ords) . "\n");
}
#char_string_test();
sub affine_enc_test {
	print("Encrypting 'affine':\t" . affine_enc(5,8,"affine") . "\n");
}
#affine_enc_test();
sub affine_dec_test {
	print("Decrypting 'ihhwvc':\t" . affine_dec(5,8,"ihhwvc") . "\n");
}
#affine_dec_test();
