import React, { useState, useEffect } from 'react';
import { Calendar, ChevronDown, ChevronUp, BarChart2, PieChart as PieChartIcon, Users, Phone, FileText, CheckCircle, XCircle } from 'lucide-react';
import axios from "axios";
import API_URL from "../config";
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer,
  Cell,
  PieChart,
  Pie,
  Legend,

} from "recharts";
import LeadsPopup from '../components/leadsPopup';;

const Home = () => {
  const [showPopup, setShowPopup] = useState(false);
  const [modalTitle, setModalTitle] = useState('');
  const [modalLeads, setModalLeads] = useState([]);
  const [activeItem, setActiveItem] = useState('dashboard');
  const [calls, setCalls] = useState([]);
  const [leads, setLeads] = useState([]);
  const [employees, setEmployees] = useState([]);
  const [employeeStats, setEmployeeStats] = useState([]);
  const interestedLeads = leads.filter(lead => lead.status === 'Interested');
  const callBackLeads = leads.filter(lead => lead.status === 'Call Back');
  const noRequirementLeads = leads.filter(lead => lead.status === 'No Requirement');
  const followUps = leads.filter(lead => lead.status === 'Follow up');
  const documentRejects = leads.filter(lead => lead.status === 'Document Reject');
  const documentsPending = leads.filter(lead => lead.status === 'Document Pending');
  const fileLogins = leads.filter(lead => lead.status === 'File Login');
  const loanSections = leads.filter(lead => lead.status === 'Loan Section');
  const loanDisbursements = leads.filter(lead => lead.status === 'Loan Disbursement');
  const homeLoanLeads = leads.filter(lead => lead.loan_type === 'Home Loan');
  const mortgageLoanLeads = leads.filter(lead => lead.loan_type === 'Mortgage Loan');
  const userCarLoanLeads = leads.filter(lead => lead.loan_type === 'User Car Loan');
  const businessLoanLeads = leads.filter(lead => lead.loan_type === 'Business Loan');
  const personalLoanLeads = leads.filter(lead => lead.loan_type === 'Personal Loan');
  const dodLoanLeads = leads.filter(lead => lead.loan_type === 'DOD');
  const ccOdLeads = leads.filter(lead => lead.loan_type === 'CC/OD');
  const cgtmsmeLeads = leads.filter(lead => lead.loan_type === 'CGTMSME');
  const mutualFundLeads = leads.filter(lead => lead.loan_type === 'Mutual Fund');
  const insuranceLeads = leads.filter(lead => lead.loan_type === 'Insurance');
  const otherLeads = leads.filter(lead => lead.loan_type === 'Other');
  
  const [expandedChart, setExpandedChart] = useState(null);
    const getTodayRange = () => {
    const now = new Date();
    const firstDay = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const lastDay = new Date(now.getFullYear(), now.getMonth(), now.getDate()+1 );
    const format = (date) => {
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const day = String(date.getDate()).padStart(2, '0');
      return `${year}-${month}-${day}`;
    };
    return {
      from: format(firstDay),
      to: format(lastDay),
    };
  };

  useEffect(() => {
    fetchData(fromDate, toDate);

  },[]);
  const { from, to } = getTodayRange();
  const [fromDate, setFromDate] = useState(from);
  const [toDate, setToDate] = useState(to);



  const fetchData = async (startDate, endDate) => {
    // console.log("Fetching calls from", startDate, "to", endDate);
    try {
      const callResponse = await axios.get(`${API_URL}/callsByDates`, {
        params: { startDate, endDate },
      });
      const leadResponse = await axios.get(`${API_URL}/getLeadsByDate`, {
        params: { startDate, endDate },
      });
      const employeeResponse = await axios.get(`${API_URL}/employees`);
    //  console.log("Response from API:", response.data.calls);
      setCalls(callResponse.data.calls);
      setLeads(leadResponse.data);
      setEmployees(employeeResponse.data.employees);
    } catch (error) {
      // console.log("==================================> its error", error);
      console.error("Error fetching calls by date range", error);
      return [];
    }
  };

  const generateEmployeeStats = (employees, leads, calls) => {
  return employees.map((emp) => {
    const empLeads = leads.filter((lead) => lead.person_id === emp.emp_id);
    const empCalls = calls.filter((call) => call.emp_id === emp.emp_id);

    return {
      id: emp.emp_id,
      name: emp.ename,
      avatar: emp.ename
        ?.split(" ")
        .map((n) => n[0])
        .join("")
        .toUpperCase(),
      totalCalls: empCalls.length,
      totalLeads: empLeads.length,
      interestedLeads: empLeads.filter((lead) => lead.status === "Interested").length,
    };
  });
};

const handleMetricClick = (title) => {
  setModalTitle(title);

  // Conditional logic to set data according to title
  if (title === 'Total Calls') {
    setModalLeads(calls); // Assuming you have this array already
  } else if (title === 'Total Leads') {
    setModalLeads(leads); // Assuming you have this array already
  } else if (title === 'Interested Leads') {
    setModalLeads(interestedLeads); // Assuming you have this array already 
  }
  else if (title === 'Follow ups') {  
    setModalLeads(followUps); // Assuming you have this array already
  }
  else if (title === 'File Login') {
    setModalLeads(fileLogins); // Assuming you have this array already
  }
  else if (title === 'Documents Pending') {
    setModalLeads(documentsPending); // Assuming you have this array already
  }

  setShowPopup(true);
};

useEffect(() => {
  const stats = generateEmployeeStats(employees, leads, calls);
  setEmployeeStats(stats);
}, [employees, leads, calls]);

  const metricsData1 = [
    { title: 'Total Calls', value: calls.length, icon: <Phone className="w-5 h-5" />},
    { title: 'Total Leads', value: leads.length, icon: <Users className="w-5 h-5" />},
  ];

  const matricsData2 = [
    { title: 'Interested Leads', value: interestedLeads.length, icon: <CheckCircle className="w-5 h-5" /> },
    { title: 'Follow ups', value: followUps.length, icon: <FileText className="w-5 h-5" /> },
    { title: 'File Login', value: fileLogins.length, icon: <FileText className="w-5 h-5" /> },
    { title: 'Documents Pending', value: documentsPending.length, icon: <XCircle className="w-5 h-5" /> }
  ];

const leadsData = [
  { name: "Interested", value: interestedLeads.length, color: "#3b82f6" },         // Blue
  { name: "Call Back", value: callBackLeads.length, color: "#60a5fa" },           // Sky Blue
  { name: "Follow up", value: followUps.length, color: "#a5b4fc" },               // Indigo
  { name: "No Requirement", value: noRequirementLeads.length, color: "#f87171" }, // Red
  { name: "Document Reject", value: documentRejects.length, color: "#10b981" },   // Green
  { name: "Document Pending", value: documentsPending.length, color: "#f59e0b" }, // Amber
  { name: "File Login", value: fileLogins.length, color: "#6366f1" },             // Indigo
  { name: "Loan Section", value: loanSections.length, color: "#ec4899" },         // Pink
  { name: "Loan Disbursement", value: loanDisbursements.length, color: "#22d3ee" } // Cyan
];
const pieData = [
  { name: 'Home Loans', value: homeLoanLeads.length, color: '#3b82f6' },
  { name: 'User Car Loans', value: userCarLoanLeads.length, color: '#f97316' },
  { name: 'Business Loans', value: businessLoanLeads.length, color: '#f59e0b' },
  { name: 'Personal Loans', value: personalLoanLeads.length, color: '#10b981' },
  { name: 'DOD Loans', value: dodLoanLeads.length, color: '#f43f5e' },
  { name: 'Mortgage Loans', value: mortgageLoanLeads.length, color: '#8b5cf6' },
  { name: 'CC/OD', value: ccOdLeads.length, color: '#4ade80' },
  { name: 'CGTMSME', value: cgtmsmeLeads.length, color: '#a78bfa' },
  { name: 'Mutual Fund', value: mutualFundLeads.length, color: '#8b5cf6' },
  { name: 'Insurance', value: insuranceLeads.length, color: '#ec4899' },
  { name: 'Other', value: otherLeads.length, color: '#f43f5e' }
];

  const MetricCard = ({ title, value, icon}) => (
    <div className="bg-gradient-to-br from-white to-gray-50 rounded-xl shadow-sm border border-gray-100 p-6 hover:shadow-md transition-all duration-300 group">
      <div className="flex justify-between items-start">
        <div>
          <h3 className="text-gray-500 text-sm font-medium mb-2 flex items-center gap-2">
            {icon} {title}
          </h3>
          <p className="text-3xl font-bold text-gray-900">{value.toLocaleString()}</p>
        </div>
      </div>
    </div>
  );

const CustomPieChart = ({ data }) => {
  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
      <h2 className="text-lg font-semibold text-gray-700 mb-4">
        Leads by Loan Type
      </h2>

      <div className="flex flex-col md:flex-row justify-center items-center gap-8">
        {/* Pie Chart */}
        <div className="w-full md:w-1/2 h-[300px]">
          <ResponsiveContainer width="100%" height="100%">
            <PieChart>
              <Pie
                data={data}
                dataKey="value"
                nameKey="name"
                cx="50%"
                cy="50%"
                outerRadius={90}
                label
              >
                {data.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={entry.color} />
                ))}
              </Pie>
              <Tooltip
                contentStyle={{ fontSize: "13px" }}
                labelStyle={{ fontWeight: "bold" }}
              />
            </PieChart>
          </ResponsiveContainer>
        </div>

        {/* Legend on the right */}
        <div className="flex flex-col space-y-2">
          {data.map((entry, index) => (
            <div key={index} className="flex items-center gap-2">
              <span
                className="w-4 h-4 rounded-full inline-block"
                style={{ backgroundColor: entry.color }}
              ></span>
              <span className="text-sm text-gray-700 font-medium">
                {entry.name}
              </span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

const CustomBarChart = ({ data, title = "Bar Chart", height = 380 }) => {
  return (
    <div
      className="w-full bg-white p-4 rounded-xl shadow-md"
      style={{ height: `${height}px` }}
    >
      <h2 className="text-lg font-semibold text-gray-700 mb-4">{title}</h2>
      <ResponsiveContainer width="100%" height="100%">
        <BarChart
          data={data}
          barSize={28}
          barGap={2}
          barCategoryGap="20%"
          margin={{ top: 20, right: 30, left: 20, bottom: 80 }}
        >
          <XAxis
            dataKey="name"
            tick={{ fontSize: 11 }}
            angle={-45}
            textAnchor="end"
            interval={0}
          />
          <YAxis />
          <Tooltip
            contentStyle={{ fontSize: "13px" }}
            labelStyle={{ fontWeight: "bold" }}
          />
          <Bar dataKey="value" radius={[6, 6, 0, 0]}>
            {data.map((entry, index) => (
              <Cell key={`cell-${index}`} fill={entry.color} />
            ))}
          </Bar>
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
};


  return (
    <div className="flex flex-col items-center bg-gradient-to-b from-gray-50 to-gray-100 min-h-screen p-6 md:p-8 space-y-8">
      <div className="w-full max-w-7xl">
<div className="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
  <h1 className="text-3xl md:text-4xl font-bold text-gray-800">
    Dashboard
  </h1>

  <div className="flex items-end gap-4 bg-white p-3 rounded-md shadow-sm border">
    {/* From Date */}
    <div className="flex flex-col">
      <label className="text-sm font-medium text-gray-600 mb-1">From Date</label>
      <input
        type="date"
        value={fromDate}
        max={new Date().toISOString().split("T")[0]}
        onChange={(e) => setFromDate(e.target.value)}
        className="border rounded px-2 py-1 text-sm"
      />
    </div>

    {/* To Date */}
    <div className="flex flex-col">
      <label className="text-sm font-medium text-gray-600 mb-1">To Date</label>
      <input
        type="date"
        value={toDate}
        onChange={(e) => setToDate(e.target.value)}
        
        className="border rounded px-2 py-1 text-sm"
      />
    </div>

    {/* Go Button */}
    <div className="flex items-end">
      <button
        onClick={() => fetchData(fromDate, toDate)}
        className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition font-medium text-sm"
      >
        Go
      </button>
    </div>
  </div>
</div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          {metricsData1.map((metric, index) => (
            <div key={index} onClick={() => handleMetricClick(metric.title)} className="cursor-pointer">
              <MetricCard 
                title={metric.title} 
                value={metric.value} 
                icon={metric.icon}
              />
            </div>
          ))}
        </div>
        <LeadsPopup
          isOpen={showPopup}
          onClose={() => setShowPopup(false)}
          title={modalTitle}
          leads={modalLeads}
        />


        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 mb-8">
          <h2 className="text-2xl font-bold mb-6 text-gray-800 flex items-center gap-2">
            <Users className="w-6 h-6 text-blue-500" /> Lead Status Overview
          </h2>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            {matricsData2.map((metric, index) => (
            <div key={index} onClick={() => handleMetricClick(metric.title)} className="cursor-pointer">
              <MetricCard 
                title={metric.title} 
                value={metric.value} 
                icon={metric.icon}
              />
            </div>
            ))}
          </div>

            <CustomBarChart data={leadsData} title="Leads by Status" />


        </div>

        <div className="grid grid-cols-1 gap-8 mb-8">
          <CustomPieChart data={pieData} />
          <CustomBarChart data={pieData} title="Leads by Loan Type" height={400} />
        </div>

        <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
          <div className="p-6 border-b border-gray-200 bg-gradient-to-r from-blue-50 to-gray-50">
            <h3 className="text-xl font-semibold text-gray-800 flex items-center gap-2">
              <Users className="w-5 h-5 text-blue-500" /> Employee Performance
            </h3>
          </div>
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">#</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Employee</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Total Calls</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Total Leads</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Interested Leads</th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {employeeStats.map((emp, idx) => (
                  <tr key={idx} className="hover:bg-gray-50 transition-colors duration-150">
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{emp.id}</td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center">
                        <div className="flex-shrink-0 h-10 w-10 flex items-center justify-center rounded-full bg-blue-100 text-blue-600 font-medium">
                          {emp.avatar}
                        </div>
                        <div className="ml-4">
                          <div className="text-sm font-medium text-gray-900">{emp.name}</div>
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-700">{emp.totalCalls}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-700">{emp.totalLeads}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-700">{emp.interestedLeads}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <div className="bg-gray-50 px-6 py-3 flex items-center justify-between border-t border-gray-200">
            {/* <div className="text-sm text-gray-500">
              Showing <span className="font-medium">1</span> to <span className="font-medium">4</span> of <span className="font-medium">4</span> employees
            </div> */}
            <div className="flex space-x-2">
              {/* <button className="px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
                Previous
              </button>
              <button className="px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
                Next
              </button> */}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Home;