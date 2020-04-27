
class PasswordManager {
	
	Uri filepath := ``;
	private const Str ERROR_MESSAGE := "ERROR_MESSAGE"
	private const Str MASTER_DEFAULT_NAME := "PASSMANAGERMASTER"
	private Str masterPassword := "default_password";
	private Bool customMaster := false
	private Str allPossibleChars := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#%^&*_=+-/.?<>)" // Excludes $ to avoid compiler error
	
	new make (Uri filepath, Bool c){
		f := |->| { 
			this.filepath = filepath
			tempMaster := ReadPasswordOnly(MASTER_DEFAULT_NAME)
			//echo(tempMaster)
			if(tempMaster.equals(ERROR_MESSAGE)){
				customMaster = false
				//echo("No custom master found")
			}else{
				masterPassword = tempMaster
				customMaster = true
				//echo("Custom master found")
			}
		}
		if(c) f()
	}
	
	/**
	* Generates a 6 length one time password that contains any combination of upper-case, lower-case, numbers, and characters defined 
	* in the allPossibleChars string.
	*/
	Void GenerateOTP(){
		echo("Generating OTP...")
		Int FIXED_SIZE := 6
		Str otp := ""
		for(i:=0; i<FIXED_SIZE; i++){
			otp += (allPossibleChars.get(Int.random(0..allPossibleChars.size-1))).toChar
		}
		echo(otp)
	}
	
	/**
	* Generates an new password with the given label and length and stores it in the passwords file.
	*/
	Str GeneratePassword(Str label, Int length){
		echo("Generating new password of " + length + " length...")
		Str pass := ""
		for(i:=0; i<length; i++){
			pass += (allPossibleChars.get(Int.random(0..allPossibleChars.size-1))).toChar
		}
		file := this.filepath.toFile
		file.out(true).printLine(label + "," + pass).close //"\n" + 
		return pass
	}
	
	/**
	* Views the passwords from the passwords file. If a master password exists, it requires the master password. 
	*/
	Void ViewPasswords(){
		if(!customMaster) {
			echo("WARNING: You do not have a master password set. For security reasons, please set a new master password.")
			ReadPasswordsFromFile
		}
		else{
			echo("Please enter your master password.")
			master := Env.cur.in.readLine
			if(master.equals(masterPassword)){
				echo("Reading passwords...")
				ReadPasswordsFromFile
			}else{
				echo("Incorrect master password.")
			}
		}
	}
	
	/**
	* Sets a master password if one does not exist, or overrides the old one if one does exist.
	*/
	Void SetMaster(Str master){
		file := this.filepath.toFile
		if(customMaster){
			List allPasswords := Str[,]
			file.eachLine |line| {
				if(!line.toCode.contains(MASTER_DEFAULT_NAME)){
					allPasswords.add(line.toCode)
				}
			}
			//TODO Fix the out statements
			file.out(true).printLine(MASTER_DEFAULT_NAME + "," + master)	// I have no idea why this won't actually add anything to the file.
			allPasswords.each |Str s| {
				file.out(true).printLine(s) // I have no idea why this won't actually add anything to the file.
				//echo(s)
			}
		}else{
			file.out(true).printLine(MASTER_DEFAULT_NAME + "," + master) // I have no idea why this won't actually add anything to the file.
			customMaster = true
		}
		masterPassword = master
	}
	
	/**
	* Searches for the password associated with the given label and returns that password if found. If 
	* that label does not exist, it returns the ERROR_MESSAGE instead.
	*/
	private Str ReadPasswordOnly(Str name){
		contents := "a"
		file := this.filepath.toFile
		file.eachLine |line| {
			if(line.toCode.contains(name)){
				//echo("FOUND!!!")
				contents = line.toCode
				count := 0
				finalCount := 0
				contents.each |Int c| {
					if(c.equals(',')){
						finalCount = count
					}else{
						count++
					}
				}
				contents = contents[finalCount+1..contents.size-2]
				//return contents
				//echo("THIS SHOULDN'T PRINT " + contents)
			}
		}
		//return ERROR_MESSAGE
		if(contents.equals("a")){
			return ERROR_MESSAGE
		}else{
			return contents
		}
	}
	
	private Void ReadPasswordsFromFile(){
		file := this.filepath.toFile
		file.eachLine |line| { echo(line.toCode) }
	}
	
}
