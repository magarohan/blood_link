const BloodBank = require("../models/bloodBankModel");

const getAllBloodBanks = async (req, res) => {
    try {
        const bloodBanks = await BloodBank.find({});
        res.status(200).json(bloodBanks);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const addBloodBank = async (req, res) => {
    const { name, location, contact } = req.body;

    try {
        const newBloodBank = await BloodBank.create({ name, location, contact });
        res.status(201).json(newBloodBank);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

module.exports = { getAllBloodBanks, addBloodBank };
