using build

class Build : BuildPod {

	new make() {
		podName = "passwordGenerator"
		summary = "My Awesome PasswordGenerator Project"
		version = Version("1.0")

		meta = [
			"pod.dis" : "PasswordGenerator"
		]

		depends = [
			"sys 1.0"
		]

		srcDirs = [`fan/`]
		resDirs = [,]

		docApi = true
		docSrc = true
	}
}
