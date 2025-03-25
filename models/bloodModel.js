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
    enum: ["A", "B", "AB", "O"],
  },
  rhFactor: {
    type: String,
    required: true,
    enum: ["+", "-"], 
  },
  components: {
    wholeBlood: {
      type: Number,
      default: 0, 
    },
    redBloodCells: {
      type: Number,
      default: 0, 
    },
    whiteBloodCells: {
      type: Number,
      default: 0,
    },
    platelets: {
      type: Number,
      default: 0,
    },
    plasma: {
      type: Number,
      default: 0, 
    },
    cryoprecipitate: {
      type: Number,
      default: 0, 
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
    default: Date.now, 
  },
});

module.exports = mongoose.model("Blood", bloodSchema);