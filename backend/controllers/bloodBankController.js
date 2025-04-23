const BloodBank = require("../models/bloodBankModel");
const jwt = require("jsonwebtoken");

const createToken = (id) => {
    return jwt.sign({ id }, process.env.SECRET, { expiresIn: "3d" });
};

// Get all blood banks
const getAllBloodBanks = async (req, res) => {
    try {
        const bloodBanks = await BloodBank.find({}, "-password");
        res.status(200).json(bloodBanks);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Register a new blood bank
const addBloodBank = async (req, res) => {
    const { name, address, lalitude, longitude, contact, email, password } = req.body;

    try {
        const newBloodBank = await BloodBank.signup(name, address, lalitude, longitude, contact, email, password );
        const token = createToken(newBloodBank._id);
        res.status(201).json({ bloodBank: newBloodBank, token });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

// Login blood bank
const loginBloodBank = async (req, res) => {
    const { email, password } = req.body;

    try {
        const bloodBank = await BloodBank.login(email, password);
        const token = createToken(bloodBank._id);
        res.status(200).json({ bloodBank, token });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

module.exports = { getAllBloodBanks, addBloodBank, loginBloodBank };
