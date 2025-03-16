const mongoose = require('mongoose');
const Blood = require('../models/bloodModel');

//get blood by bank
const getBloodByBank = async (req, res) => {
    const { bloodBankId } = req.params;
    
    if (!mongoose.Types.ObjectId.isValid(bloodBankId)) {
        return res.status(404).json({ error: "Invalid blood bank ID" });
    }

    try {
        const bloodRecords = await Blood.find({ bloodBankId });
        res.status(200).json(bloodRecords);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Get all blood entries
const getAllBlood = async (req, res) => {
    try {
        const bloodRecords = await Blood.find({}).sort({ createdAt: -1 });
        res.status(200).json(bloodRecords);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Get a single blood record
const getBloodById = async (req, res) => {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
        return res.status(404).json({ error: "No such blood record" });
    }

    try {
        const bloodRecord = await Blood.findById(id);
        if (!bloodRecord) {
            return res.status(404).json({ error: "No such blood record" });
        }
        res.status(200).json(bloodRecord);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Add a new blood record
const addBlood = async (req, res) => {
    const { bloodBankId, bloodType, rhFactor, components } = req.body;

    if (!mongoose.Types.ObjectId.isValid(bloodBankId)) {
        return res.status(400).json({ error: "Invalid blood bank ID" });
    }

    try {
        const existingRecord = await Blood.findOne({ bloodBankId, bloodType, rhFactor });
        if (existingRecord) {
            return res.status(400).json({ error: "Blood record already exists for this blood bank" });
        }

        const newBloodRecord = await Blood.create({ bloodBankId, bloodType, rhFactor, components });
        res.status(201).json(newBloodRecord);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};


// Update an existing blood record
const updateBlood = async (req, res) => {
    const { id } = req.params;
    const { components } = req.body;

    if (!mongoose.Types.ObjectId.isValid(id)) {
        return res.status(400).json({ error: "Invalid ID format" });
    }

    try {
        const updatedBloodRecord = await Blood.findByIdAndUpdate(
            id,
            { $set: { components } },
            { new: true, runValidators: true }
        );

        if (!updatedBloodRecord) {
            return res.status(404).json({ error: "No such blood record" });
        }

        res.status(200).json(updatedBloodRecord);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};


// Delete a blood record
const deleteBlood = async (req, res) => {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
        return res.status(404).json({ error: "No such blood record" });
    }

    try {
        const deletedBloodRecord = await Blood.findByIdAndDelete(id);
        if (!deletedBloodRecord) {
            return res.status(404).json({ error: "No such blood record" });
        }
        res.status(200).json({ message: "Blood record deleted successfully" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Search blood by type and Rh factor
const searchBlood = async (req, res) => {
    const { bloodType, rhFactor } = req.query;

    try {
        const bloodRecords = await Blood.find({ bloodType, rhFactor });
        if (bloodRecords.length === 0) {
            return res.status(404).json({ error: "No matching blood records found" });
        }
        res.status(200).json(bloodRecords);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

module.exports = {
    getAllBlood,
    getBloodById,
    addBlood,
    updateBlood,
    deleteBlood,
    searchBlood,
    getBloodByBank
};