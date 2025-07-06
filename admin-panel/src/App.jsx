import React from "react";
import {
  BrowserRouter as Router,
  Routes,
  Route,
  useLocation,
} from "react-router-dom";
import Home from "./screens/Home";
import Sidebar from "./components/sidebar";
import UserList from "./screens/users/Screens/userlist";
import LeadsList from "./screens/leads/Screens/leadslist";
import LeadDetailScreen from "./screens/leads/Screens/leadsdetailsscreen";
import AttendanceScreen from "./screens/attendance/attendance_screen";
import UserDetailScreen from "./screens/users/Screens/userdetailsscreen";
import TaskScreen from "./screens/tasks/Screens/taskScreen";
import TemplateScreen from "./screens/template/templateScreen";

// Custom layout component that uses useLocation hook
const Layout = () => {
  const location = useLocation();
  const noSidebarRoutes = ["/login", "/signup"];

  return (
    <div className="flex">
      {/* Conditionally render Sidebar */}
      {!noSidebarRoutes.includes(location.pathname) && <Sidebar />}
      <div
        className={`flex-1 p-6 ${
          !noSidebarRoutes.includes(location.pathname) ? "ml-64" : ""
        }`}
      >
        <Routes>
          <Route exact path="/" element={<Home />} />
          <Route exact path="/leads" element={<LeadsList />} />

          <Route exact path="/add-users" element={<UserList />} />
          <Route exact path="/lead-details/:id" element = {<LeadDetailScreen/>}/>
          <Route exact path = "/attendance" element = {<AttendanceScreen/>}/>
          <Route exact path ="/userdetail/:emp_id" element = {<UserDetailScreen/>}/>
          <Route exact path = "/tasks" element = {<TaskScreen/>}/>
          <Route exact path = "/template" element = {<TemplateScreen/>}/>

          {/* Add more routes as needed */}
        </Routes>
      </div>
    </div>
  );
};

function App() {
  return (
    <Router>
      <Layout />
    </Router>
  );
}

export default App;
