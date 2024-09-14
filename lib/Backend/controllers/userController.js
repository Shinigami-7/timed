const User = require("../schema/userSchema");
const bcrypt = require('bcrypt');

const userRegisterController = async (req, res) => {
    try {
        const userData = new User(req.body);
        const {email} = userData;

        const userExist = await User.findOne({email});
        if(userExist){
            return res.json({message: "User already exist"})
        }else{
            const encryptedPassword = await bcrypt.hash(userData.password, 10);
            userData.password = encryptedPassword
            const savedUser = new User(userData);
            const data = await savedUser.save();
            if(data){
                    res.status(200).json({
                        message: "User created successfully",
                        email : userData.email
                    })

             }else{
                res.status(400).json({message: "User Registration Failed"});
             }
        }

        
    } catch (error) {
        console.log(error)
        res.status(500).json({message: "Internal Server Error"})
    }
}

module.exports = userRegisterController;