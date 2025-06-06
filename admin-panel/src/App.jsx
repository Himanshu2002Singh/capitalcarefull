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
import UserDetailScreen from "./screens/leads/Screens/leadsdetailsscreen";

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
          <Route exact path="/lead-details/:id" element = {<UserDetailScreen/>}/>

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
