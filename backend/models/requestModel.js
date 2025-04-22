const mongoose = require("mongoose");

const requestSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true, // Full name of the requestor
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
    location: {
      type: String,
      required: true,
    },
    components: {
      wholeBlood: {
        type: Number,
        default: 0, // Units of whole blood available
        min: 0,
      },
      redBloodCells: {
        type: Number,
        default: 0, // Units of RBCs available
        min: 0,
      },
      whiteBloodCells: {
        type: Number,
        default: 0, // Units of WBCs available
        min: 0,
      },
      platelets: {
        type: Number,
        default: 0, // Units of platelets available
        min: 0,
      },
      plasma: {
        type: Number,
        default: 0, // Units of plasma available
        min: 0,
      },
      cryoprecipitate: {
        type: Number,
        default: 0, // Units of cryoprecipitate available
        min: 0,
      },
    },
  },
  { timestamps: true } // Automatically adds createdAt and updatedAt fields
);

module.exports = mongoose.model("Request", requestSchema);
