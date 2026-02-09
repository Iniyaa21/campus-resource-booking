import { Link, Outlet } from 'react-router-dom';

function Layout() {
  return (
    <div>
      <nav style={{ padding: '1rem', background: '#f0f0f0', marginBottom: '1rem' }}>
        <Link to="/" style={{ marginRight: '1rem' }}>Home</Link>
        <Link to="/history" style={{ marginRight: '1rem' }}>History</Link>
        <Link to="/search">Search</Link>
      </nav>
      <main>
        <Outlet />
      </main>
    </div>
  );
}

export default Layout;

