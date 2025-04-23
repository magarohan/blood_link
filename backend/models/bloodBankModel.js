const mongoose = require("mongoose");
const bcrypt = require('bcrypt');
const validator = require('validator');

const bloodBankSchema = new mongoose.Schema({
  name: { type: String, required: true },
  address: { type: String, required: true },
  latitude: { type: String, required: false },
  longitude: { type: String, required: false },
  contact: { type: String, required: true },
  email: { type: String, required: true, unique: true, lowercase: true },
  password: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
});

// Signup method
bloodBankSchema.statics.signup = async function (name, location, contact, email, password) {
    if (!name || !location || !contact || !email || !password) {
        throw Error('All fields must be filled');
    }

    if (!validator.isEmail(email)) {
        throw Error('Invalid email format');
    }

    if (!validator.isMobilePhone(contact, 'any')) {
        throw Error('Invalid contact number');
    }

    const exists = await this.findOne({ email });
    if (exists) {
        throw Error('Email already in use');
    }

    const salt = await bcrypt.genSalt(10);
    const hash = await bcrypt.hash(password, salt);

    const bloodBank = await this.create({ name, location, contact, email, password: hash });
    return bloodBank;
};

// Login method
bloodBankSchema.statics.login = async function (email, password) {
    if (!email || !password) {
        throw Error('Email and password are required');
    }

    const bloodBank = await this.findOne({ email });
    if (!bloodBank) {
        throw Error('Incorrect email');
    }

    const match = await bcrypt.compare(password, bloodBank.password);
    if (!match) {
        throw Error('Incorrect password');
    }

    return bloodBank;
};

module.exports = mongoose.model("BloodBank", bloodBankSchema);
