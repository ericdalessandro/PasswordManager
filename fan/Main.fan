using [java] java.util

class Main {
	
	// Path to passwords.txt file
	static const Uri FILEPATH := `/D:/f4_projects/password_manager_resources/passwords.txt`
	
	static Void main(Str[] args)
	{
		passwordManager := PasswordManager.make(FILEPATH, true)
		
		while(true){
			echo("What action would you like to take? Enter 1: Generate OTP, 2: Generate Password, 3: View Passwords, 4: Set or change master password")
			str := Env.cur.in.readLine
			if(str.equals("1")){
				// Generate OTP
				passwordManager.GenerateOTP
				echo("\n")
			}else if(str.equals("2")){
				// Generate password
				echo("What would you like to label this password?")
				name := Env.cur.in.readLine
				echo("How long do you want the password to be? (Min=4, Max=20)")
				length := Env.cur.in.readLine
				if(length.toInt>=4 && length.toInt<=20){
					echo(passwordManager.GeneratePassword(name, length.toInt))
				}else{
					echo("Password length out of bounds.")
				}
				echo("\n")
			}else if(str.equals("3")){
				// View passwords
				passwordManager.ViewPasswords
				echo("\n")
			}else if(str.equals("4")){
				// Set or change master
				echo("Enter new master password")
				master := Env.cur.in.readLine
				passwordManager.SetMaster(master)
				echo("\n")
			}else{
				echo("Invalid input")
				echo("\n")
			}
		}
		
	}
}
