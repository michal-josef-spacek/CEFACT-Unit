package CEFACT::Unit;

use strict;
use warnings;

use Class::Utils qw(set_params);
use Data::CEFACT::Unit;
use File::Share ':all';
use IO::File;
use List::Util 1.33 qw(any);
use Text::CSV_XS;

our $VERSION = 0.01;

sub new {
	my ($class, @params) = @_;

	# Create object.
	my $self = bless {}, $class;

	# Units list.
	$self->{'units'} = [];

	# Process parameters.
	set_params($self, @params);

	# Init all units.
	if (! @{$self->{'units'}}) {
		$self->_init;
	}

	return $self;
}

sub check_common_code {
	my ($self, $common_code) = @_;

	my $ret;
	if (any { $_->common_code eq $common_code } @{$self->{'units'}}) {
		$ret = 1;
	} else {
		$ret = 0;
	}

	return $ret;
}

sub _init {
	my $self = shift;

	# Object.
	my $csv = Text::CSV_XS->new({
		'binary' => 1,
		'escape_char' => '"',
		'quote_char' => '"',
		'sep_char' => ',',
	});

	# Parse file.
	my $fh = IO::File->new;
	my $csv_file = dist_file('CEFACT-Unit', 'code-list.csv');
	$fh->open($csv_file, 'r');
	my $i = 0;
	while (my $columns_ar = $csv->getline($fh)) {
		if (! @{$columns_ar}) {
			last;
		}
		$i++;

		# Header.
		if ($i == 1) {
			next;
		}

		for (my $i = 0; $i < @{$columns_ar}; $i++) {
			$columns_ar->[$i] = $columns_ar->[$i] ne '' ? $columns_ar->[$i] : undef;
		}

		push @{$self->{'units'}}, Data::CEFACT::Unit->new(
			'common_code' => $columns_ar->[1],
			'conversion_factor' => $columns_ar->[6],
			'description' => $columns_ar->[3],
			'level_category' => $columns_ar->[4],
			'symbol' => $columns_ar->[5],
			'name' => $columns_ar->[2],
			'status' => $columns_ar->[0],
		);
	}
	$fh->close;

	return;
}

1;

__END__
