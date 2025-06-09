import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import axios from "axios";
import API_URL from "../../../config";
import * as XLSX from "xlsx";

const LeadDetailScreen = () => {
  const { id } = useParams();
  const [user, setUser] = useState(null);
  const [lead, setLead] = useState(null);
  const [calls, setCalls] = useState([]);
  const [personNames, setPersonNames] = useState({});
  const [histories, setHistories] = useState([]);
  const [activeTab, setActiveTab] = useState("calls");
  const [isLoading, setIsLoading] = useState(false);
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(0);
  const itemsPerPage = 50;

  const downloadexcel = () => {
    const filteredCalls = calls.map((call) => ({
      "Called By": personNames[call.emp_id] || "N/A",
      "Employee ID": call.emp_id || "N/A",
      "Lead ID": call.lead_id || "N/A",
      "Name": lead?.name || "N/A",
      "Phone": call.number || "N/A",
      "Remark": call.remark || "N/A",
      "Created At": new Date(call.createdAt).toLocaleString("en-IN", {
        dateStyle: "medium",
        timeStyle: "short",
      }),
    }));

    const ws = XLSX.utils.json_to_sheet(filteredCalls);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, "Calls");
    XLSX.writeFile(wb, "calls_data.xlsx");
  };

  const fetchLeadDetails = async () => {
    try {
      const response = await axios.get(`${API_URL}/getLead/${id}`);
      setLead(response.data);
    } catch (error) {
      console.error("Error fetching lead details: ", error);
    }
  };

  const fetchCallDetails = async () => {
    try {
      const response = await axios.get(`${API_URL}/callsByLeadId/${id}`);
      const calls = response.data.calls;
      setCalls(calls);

      const nameMap = {};
      await Promise.all(
        calls.map(async (call) => {
          if (call.emp_id) {
            try {
              const personRes = await axios.get(
                `${API_URL}/employees/${call.emp_id}`
              );
              if (personRes.status === 200) {
                nameMap[call.emp_id] = personRes.data.ename;
              }
            } catch (err) {
              nameMap[call.emp_id] = "N/A";
              console.error("Error fetching person name:", call.emp_id, err);
            }
          }
        })
      );
      setPersonNames(nameMap);
    } catch (error) {
      console.error("Error fetching calls: ", error);
    }
  };

  const fetchHistoryDetails = async () => {
    try {
      const res = await axios.get(`${API_URL}/histories/${id}`);
      setHistories(res.data.history || []);
    } catch (error) {
      console.error("Error fetching history data:", error);
    }
  };

  useEffect(() => {
    fetchLeadDetails();
    fetchCallDetails();
    fetchHistoryDetails();
  }, []);

  return (
    <div style={{ padding: "20px" }}>
      <div className="flex justify-between items-center mb-4">
        <h1 className="text-2xl font-bold">Lead Details</h1>
        <button
          onClick={downloadexcel}
          className="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-700"
        >
          Download Excel
        </button>
      </div>

      {lead ? (
        <div className="border rounded p-4 mb-6 bg-gray-100">
          <p><strong>Name:</strong> {lead.name}</p>
          <p><strong>Email:</strong> {lead.email}</p>
          <p><strong>Phone:</strong> {lead.number}</p>
          <p><strong>Assigned to :</strong> {lead.person_id}-{lead.owner}</p>
          <p><strong>Status:</strong> {lead.status}</p>
          <p><strong>Source:</strong> {lead.source}</p>
          <p><strong>Priority:</strong> {lead.priority}</p>
          <p><strong>Next Meeting:</strong> {new Date(lead.next_meeting).toLocaleString("en-IN", { dateStyle: "medium", timeStyle: "short" })}</p>
          <p><strong>Loan Type:</strong> {lead.loan_type}</p>
          <p><strong>Estimated Budget:</strong> {lead.est_budget}</p>
          <p><strong>Refrence:</strong> {lead.refrence}</p>
          <p><strong>Remark:</strong> {lead.remark}</p>
          <p><strong>Created At:</strong> {new Date(lead.createdAt).toLocaleString("en-IN", { dateStyle: "medium", timeStyle: "short" })}</p>
          <p><strong>Address:</strong> {lead.address}</p>
          <p><strong>Description:</strong> {lead.description}</p>
        </div>
      ) : (
        <p>Loading Lead details...</p>
      )}

      {/* Toggle */}
      <div className="flex gap-4 mb-4">
        <button
          onClick={() => setActiveTab("calls")}
          className={`px-4 py-2 rounded ${activeTab === "calls" ? "bg-blue-600 text-white" : "bg-gray-200"}`}
        >
          Call Details
        </button>
        <button
          onClick={() => setActiveTab("history")}
          className={`px-4 py-2 rounded ${activeTab === "history" ? "bg-blue-600 text-white" : "bg-gray-200"}`}
        >
          History Details
        </button>
      </div>

      {activeTab === "calls" ? (
        <>
          <h2 className="text-xl font-bold mb-4">Call Details</h2>
          {calls.length ? (
            <div className="border rounded p-4 mb-6 bg-gray-100">
              <p><strong>Total Calls:</strong> {calls.length}</p>
            </div>
          ) : (
            <p>No related calls found</p>
          )}
          <h3 className="text-lg font-bold mb-2">All Calls</h3>
          <table className="table-auto w-full border-collapse border border-gray-300">
            <thead>
              <tr className="bg-gray-200">
                <th className="border px-4 py-2">Called By</th>
                <th className="border px-4 py-2">Phone</th>
                <th className="border px-4 py-2">Remark</th>
                <th className="border px-4 py-2">Date-Time</th>
              </tr>
            </thead>
            <tbody>
              {calls.map((call, index) => (
                <tr key={index} className="hover:bg-gray-50">
                  <td className="border px-4 py-2">{personNames[call.emp_id] || "N/A"}</td>
                  <td className="border px-4 py-2">{call.number}</td>
                  <td className="border px-4 py-2">{call.remark}</td>
                  <td className="border px-4 py-2">{new Date(call.createdAt).toLocaleString("en-IN", { dateStyle: "medium", timeStyle: "short" })}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </>
      ) : (
        <>
          <h2 className="text-xl font-bold mb-4">History Details</h2>
          {histories.length ? (
            <div className="border rounded p-4 mb-6 bg-gray-100">
              <p><strong>Total History:</strong> {histories.length}</p>
            </div>):(<p>No related History Record found</p>)}
            <h3 className="text-lg font-bold mb-2">All History</h3>
            <table className="table-auto w-full border-collapse border border-gray-300">
              <thead>
                <tr className="bg-gray-200">
                  <th className="border px-4 py-2">By</th>
                  <th className="border px-4 py-2">Next Meeting</th>
                  <th className="border px-4 py-2">Status</th>
                  <th className="border px-4 py-2">Remark</th>
                  <th className="border px-4 py-2">At</th>
                </tr>
              </thead>
              <tbody>
                {histories.map((item, index) => (
                  <tr key={index} className="hover:bg-gray-50">
                    <td className="border px-4 py-2">{item.owner || "N/A"}</td>
                    <td className="border px-4 py-2">{item.next_meeting ? new Date(item.next_meeting).toLocaleString("en-IN", { dateStyle: "medium", timeStyle: "short" }) : "--"}</td>
                    <td className="border px-4 py-2">{item.status || "--"}</td>
                    <td className="border px-4 py-2">{item.remark || "--"}</td>
                    <td className="border px-4 py-2">{item.createdAt ? new Date(item.createdAt).toLocaleString("en-IN", { dateStyle: "medium", timeStyle: "short" }) : "--"}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          
          
        </>
      )}
    </div>
  );
};

export default LeadDetailScreen;
