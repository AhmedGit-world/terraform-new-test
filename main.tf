resource "random_pet" "mypet" {
prefix = "MR"
separator = "."
length = "1"
}

output my_pet {
  value = random_pet.mypet.id
  description = "India"
}
