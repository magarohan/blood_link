const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const validator = require('validator');

const Schema = mongoose.Schema;

const userSchema = new Schema({
    fullName: {
        type: String,
        required: [true, 'Full name is required'],
        trim: true,
    },
    bloodGroup: {
        type: String,
        required: [true, 'Blood group is required'],
        enum: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
    },
    location: {
        type: String,
        required: [true, 'Location is required'],
        trim: true,
    },
    email: {
        type: String,
        required: [true, 'Email is required'],
        unique: true,
        trim: true,
        validate: {
            validator: validator.isEmail,
            message: 'Invalid email format',
        },
    },
    phoneNumber: {
        type: String,
        required: [true, 'Phone number is required'],
        unique: true,
        validate: {
            validator: function (v) {
                return /^[0-9]{10}$/.test(v); 
            },
            message: 'Invalid phone number format',
        },
    },
    password: {
        type: String,
        required: [true, 'Password is required'],
        minlength: [6, 'Password must be at least 6 characters long'],
    },
    userType:{
        type: String,
        enum: ['donor', 'staff', 'admin'],
        default: 'donor',
    },
}, { timestamps: true });

// Signup a user
userSchema.statics.signup = async function (fullName, bloodGroup, location, email, phoneNumber, password) {
    const exists = await this.findOne({ email });
    if (exists) {
        throw Error('Email already in use');
    }

    const salt = await bcrypt.genSalt(10);
    const hash = await bcrypt.hash(password, salt);

    const user = await this.create({
        fullName,
        bloodGroup,
        location,
        email,
        phoneNumber,
        password: hash,
    });

    return user;
};

//login user
userSchema.statics.login = async function (email, password) {
    if(!email && !password){
        throw Error('Email and password are required');
    }
    const user = await this.findOne({ email });
    if (!user) {
        throw Error('Incorrect email');
    }
    const match = await bcrypt.compare(password, user.password)
    if (!match) {
        throw Error('Incorrect password');
    }
    return user;
}
module.exports = mongoose.model('User', userSchema);
