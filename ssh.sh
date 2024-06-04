ssh-keygen -t ed25519 -C "cieslakluiz@gmail.com"

echo "---------------------------"
cat ~/.ssh/id_rsa.pub
echo "---------------------------"

echo "Copy and add the content above to https://github.com/settings/ssh/new"