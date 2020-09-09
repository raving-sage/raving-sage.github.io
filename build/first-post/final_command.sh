a=$(pandoc -t html find_min.md)
perl -s -pi.bak -e's/STATIMPOSTCONTENT/$to/g' -- -to="$a" first-post.html
