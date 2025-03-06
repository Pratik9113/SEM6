import './App.css';
import Layout from './components/Layout/Layout.js';
import Home from './components/Home/Home.js';
import ScrollToTop from 'react-scroll-to-top';
import { useTheme } from './context/ThemeContent.js'; // Adjust the path as necessary
import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Education from './components/Education/Education.js';
import Tech from './components/Tech/Tech.js';
import Projects from './components/Projects/Projects.js';
import Experience from './components/Experience/Experience.js';
import Contact from './components/contact/Contact.js';
// import Achievement from './components/Acheivement/Achievement.js';
function App() {
  const [theme] = useTheme();
  return (
    <div id={theme}>
      <ToastContainer />
      <Router>
        <Layout />
        <Routes>
          <Route path='/' element={<Home />} />
          <Route path='/about' element={<Home />} />
          <Route path='/education' element={<Education />} />
          <Route path='/tech' element={<Tech />} />
          <Route path='/project' element={<Projects />} />
          <Route path='/experience' element={<Experience />} />
          {/* <Route path='/achievement' element={<Achievement />} /> */}
          <Route path='/contact' element={<Contact />} />
        </Routes>
      </Router>
      <ScrollToTop
        smooth
        color='#f29f67'
        style={{ backgroundColor: '#1e1e2c', borderRadius: '80px' }}
      />
    </div>
  );
}

export default App;
