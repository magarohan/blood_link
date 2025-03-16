const mongoose = require("mongoose");

const bloodSchema = new mongoose.Schema({
  bloodBankId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "BloodBank", 
    required: true,
  },
  bloodType: {
    type: String,
    required: true,
    enum: ["A", "B", "AB", "O"], // Valid blood groups
  },
  rhFactor: {
    type: String,
    required: true,
    enum: ["+", "-"], // Positive or Negative
  },
  components: {
    wholeBlood: {
      type: Number,
      default: 0, // Units of whole blood available
    },
    redBloodCells: {
      type: Number,
      default: 0, // Units of RBCs available
    },
    whiteBloodCells: {
      type: Number,
      default: 0, // Units of WBCs available
    },
    platelets: {
      type: Number,
      default: 0, // Units of platelets available
    },
    plasma: {
      type: Number,
      default: 0, // Units of plasma available
    },
    cryoprecipitate: {
      type: Number,
      default: 0, // Units of cryoprecipitate available
    },
  },
  // donations: [
  //   {
  //     donorId: {
  //       type: mongoose.Schema.Types.ObjectId,
  //       ref: "Donor", // Reference to a Donor collection
  //     },
  //     date: {
  //       type: Date,
  //       default: Date.now, // Donation date
  //     },
  //     quantity: {
  //       type: Number,
  //       required: true, // Quantity of blood donated in mL
  //     },
  //     componentType: {
  //       type: String,
  //       enum: [
  //         "wholeBlood",
  //         "redBloodCells",
  //         "platelets",
  //         "plasma",
  //         "cryoprecipitate",
  //       ], // Type of component donated
  //     },
  //   },
  // ],
  createdAt: {
    type: Date,
    default: Date.now, // Record creation date
  },
});

module.exports = mongoose.model("Blood", bloodSchema);