$gitUserName = ""
$gitUserEmail = ""

for ($i = 0; $i -lt $args.Length; $i++) {
   switch ($args[$i]) {
     "-n" {
       $i++
       $gitUserName = $args[$i]
     }
     "-e" {
       $i++
       $gitUserEmail = $args[$i]
     }
   }
}

# Git
if ($gitUserName -ne "" -and $gitUserEmail -ne "") {
  git config --global user.name $gitUserName
  git config --global user.email $gitUserEmail
}
