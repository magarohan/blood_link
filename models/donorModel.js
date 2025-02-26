const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const validator = require('validator');

const Schema = mongoose.Schema;

const donorSchema = new Schema({
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
}, { timestamps: true });

// Signup a donor
donorSchema.statics.signup = async function (fullName, bloodGroup, location, email, phoneNumber, password) {
    const exists = await this.findOne({ email });
    if (exists) {
        throw Error('Email already in use');
    }

    const salt = await bcrypt.genSalt(10);
    const hash = await bcrypt.hash(password, salt);

    const donor = await this.create({
        fullName,
        bloodGroup,
        location,
        email,
        phoneNumber,
        password: hash,
    });

    return donor;
};

// Login donor
donorSchema.statics.login = async function (email, password) {
    if (!email && !password) {
        throw Error('Email and password are required');
    }
    const donor = await this.findOne({ email });
    if (!donor) {
        throw Error('Incorrect email');
    }
    const match = await bcrypt.compare(password, donor.password)
    if (!match) {
        throw Error('Incorrect password');
    }
    return donor;
};

module.exports = mongoose.model('Donor', donorSchema);
