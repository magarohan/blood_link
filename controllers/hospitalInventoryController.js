const mongoose = require('mongoose');
const hospitalBlood = require('../models/hospitalBloodModel');

// Get all blood entries
const getAllHospitalBlood = async (req, res) => {
    try {
        const bloodRecords = await hospitalBlood.find({}).sort({ createdAt: -1 });
        res.status(200).json(bloodRecords);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Get a single blood record
const getHospitalBloodById = async (req, res) => {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
        return res.status(404).json({ error: "No such blood record" });
    }

    try {
        const bloodRecord = await hospitalBlood.findById(id);
        if (!bloodRecord) {
            return res.status(404).json({ error: "No such blood record" });
        }
        res.status(200).json(bloodRecord);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Add a new blood record
const addHospitalBlood = async (req, res) => {
    const { bloodType, rhFactor, components } = req.body;

    try {
        const newBloodRecord = await hospitalBlood.create({ bloodType, rhFactor, components });
        res.status(201).json(newBloodRecord);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

// Update an existing blood record
const updateHospitalBlood = async (req, res) => {
    const { bloodType, rhFactor, components } = req.body;

    try {
        const updatedBloodRecord = await hospitalBlood.findOneAndUpdate(
            { bloodType, rhFactor },
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
const deleteHospitalBlood = async (req, res) => {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
        return res.status(404).json({ error: "No such blood record" });
    }

    try {
        const deletedBloodRecord = await hospitalBlood.findByIdAndDelete(id);
        if (!deletedBloodRecord) {
            return res.status(404).json({ error: "No such blood record" });
        }
        res.status(200).json({ message: "Blood record deleted successfully" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Search blood by type and Rh factor
const searchHospitalBlood = async (req, res) => {
    const { bloodType, rhFactor } = req.query;

    try {
        const bloodRecords = await hospitalBlood.find({ bloodType, rhFactor });
        if (bloodRecords.length === 0) {
            return res.status(404).json({ error: "No matching blood records found" });
        }
        res.status(200).json(bloodRecords);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

module.exports = {
    getAllHospitalBlood,
    getHospitalBloodById,
    addHospitalBlood,
    updateHospitalBlood,
    deleteHospitalBlood,
    searchHospitalBlood,
};