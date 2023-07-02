(pwd() != @__DIR__) && cd(@__DIR__) # allow starting app from bin/ dir

using REoptMVC
const UserApp = REoptMVC
REoptMVC.main()
