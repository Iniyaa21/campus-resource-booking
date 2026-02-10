import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Layout from './components/Layout';
import Landing from './pages/Landing';
import History from './pages/History';
import Search from './pages/Search';
import ResourceList from './pages/ResourceList';
import AvailabilityView from './pages/AvailabilityView';
import BookingCreation from './pages/BookingCreation';
import MyBookings from './pages/MyBookings';
import NotificationsPanel from './pages/NotificationsPanel';
import './App.css';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Layout />}>
          <Route index element={<Landing />} />
          <Route path="history" element={<History />} />
          <Route path="view-resources" element={<Search />} />
        </Route>
        <Route path="/resources" element={<ResourceList />} />
        <Route path="/availability" element={<AvailabilityView />} />
        <Route path="/booking/create" element={<BookingCreation />} />
        <Route path="/my-bookings" element={<MyBookings />} />
        <Route path="/notifications" element={<NotificationsPanel />} />
      </Routes>
    </Router>
  );
}

export default App;

