const mongoose = require('mongoose');
const Donor = require('../models/donorModel');
const jwt = require('jsonwebtoken');

// Helper function to create a token
const createToken = (_id) => {
    if (!process.env.SECRET) {
        throw new Error('JWT secret is not defined');
    }
    return jwt.sign({ _id }, process.env.SECRET, { expiresIn: '3d' });
};

// Get all donors
const getAllDonors = async (req, res) => {
    try {
        const donors = await Donor.find({}).sort({ createdAt: -1 });
        res.status(200).json(donors);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Get single donor
const getDonor = async (req, res) => {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
        return res.status(404).json({ error: "No such donor" });
    }

    try {
        const donor = await Donor.findById(id);
        if (!donor) {
            return res.status(404).json({ error: "No such donor" });
        }
        res.status(200).json(donor);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Signup donor
const signupDonor = async (req, res) => {
    const { fullName, bloodGroup, location, email, phoneNumber, password } = req.body;

    try {
        const donor = await Donor.signup(fullName, bloodGroup, location, email, phoneNumber, password);

        // Create token
        const token = createToken(donor._id);

        res.status(201).json({ donor, token });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

// Login donor
const loginDonor = async (req, res) => {
    const { email, password } = req.body;

    try {
        const donor = await Donor.login(email, password);

        // Create token
        const token = createToken(donor._id);

        res.status(200).json({ donor, token });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

// Delete a donor
const deleteDonor = async (req, res) => {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
        return res.status(404).json({ error: "No such donor" });
    }

    try {
        const donor = await Donor.findByIdAndDelete(id);
        if (!donor) {
            return res.status(404).json({ error: "No such donor" });
        }
        res.status(200).json({ message: "Donor deleted successfully" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Update a donor
const updateDonor = async (req, res) => {
    const { id } = req.params;
    const updates = req.body;

    try {
        const updatedDonor = await Donor.findByIdAndUpdate(id, updates, { new: true, runValidators: true });
        if (!updatedDonor) {
            return res.status(404).json({ error: "No such donor" });
        }
        res.status(200).json(updatedDonor);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

module.exports = { getDonor, getAllDonors, signupDonor, deleteDonor, updateDonor, loginDonor };
