if (! grep { $_ eq 'synctex.gz' } @generated_exts) {
  push @generated_exts, 'synctex.gz';
}

$pdflatex = 'xelatex -synctex=1 %O %S';
