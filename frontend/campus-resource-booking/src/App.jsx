import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
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
        <Route path="/" element={<ResourceList />} />
        <Route path="/availability" element={<AvailabilityView />} />
        <Route path="/booking/create" element={<BookingCreation />} />
        <Route path="/my-bookings" element={<MyBookings />} />
        <Route path="/notifications" element={<NotificationsPanel />} />
      </Routes>
    </Router>
  );
}

export default App;

