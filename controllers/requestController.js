const Request = require('../models/requestModel');

// Get all requests
const getAllRequests = async (req, res) => {
  try {
    const requests = await Request.find();
    res.status(200).json(requests);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Get a single request by ID
const getRequestbyId = async (req, res) => {
  try {
    const request = await Request.findById(req.params.id);
    if (!request) {
      return res.status(404).json({ message: "Request not found" });
    }
    res.status(200).json(request);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Add a new request
const addRequest = async (req, res) => {
  const { name, bloodType, rhFactor, location, components } = req.body;

  try {
    const newRequest = new Request({
      name,
      bloodType,
      rhFactor,
      location,
      components,
    });

    await newRequest.save();
    res.status(201).json(newRequest);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// Update a request by ID
const updateRequest = async (req, res) => {
  try {
    const updatedRequest = await Request.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );
    if (!updatedRequest) {
      return res.status(404).json({ message: "Request not found" });
    }
    res.status(200).json(updatedRequest);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// Delete a request by ID
const deleteRequest = async (req, res) => {
  try {
    const deletedRequest = await Request.findByIdAndDelete(req.params.id);
    if (!deletedRequest) {
      return res.status(404).json({ message: "Request not found" });
    }
    res.status(200).json({ message: "Request deleted successfully" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Search for requests by blood type and Rh factor
const searchRequest = async (req, res) => {
    let { bloodType, rhFactor } = req.query;
  
    // Replace spaces (i.e. '+') with '%2B' before processing
    rhFactor = rhFactor.replace(' ', '+'); // Replace any spaces with '+'
  
    console.log("Request: GET /api/requests/search, Query:", req.query); // Check the query
  
    if (!bloodType || !rhFactor) {
      return res.status(400).json({ message: "Both bloodType and rhFactor are required" });
    }
  
    try {
      // Perform the search query
      const requests = await Request.find({
        bloodType: bloodType,
        rhFactor: rhFactor,
      });
  
      if (requests.length === 0) {
        return res.status(404).json({ message: "No requests found for the given criteria" });
      }
  
      res.status(200).json(requests);
    } catch (err) {
      console.error("Error in searchRequest:", err);
      res.status(500).json({ message: err.message });
    }
  };
  
  

module.exports = {
  getAllRequests,
  getRequestbyId,
  addRequest,
  updateRequest,
  deleteRequest,
  searchRequest,
};
