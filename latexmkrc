if (! grep { $_ eq 'synctex.gz' } @generated_exts) {
  push @generated_exts, 'synctex.gz';
}

$pdflatex = 'lualatex -synctex=1 %O %S';
