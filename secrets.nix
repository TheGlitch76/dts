let
  aboleth = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPfD2jW1s3Njx6lVmyd/91q/Xf8Z1rGbByjrWBkasnAv"];
  glitch = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF9F3+irAVmMXm399GgX4eRx4bP8lLjeZTIkkz3quRCJ"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMOdxQIC+Qn09O9P7pC52odvTCDoXeV5XDdAO6PJrAaa"
  ]; # try to keep this matching with the keys used on github for your sanity
in
{
    "secrets/keys/curseforge.age".publicKeys = aboleth ++ glitch;
}
