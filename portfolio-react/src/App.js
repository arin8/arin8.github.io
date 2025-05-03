import React from 'react';
import Navbar from './components/Navbar.jsx';
import Projects from './components/Projects.jsx';
import AboutMe from './components/AboutMe.jsx';
import Contacts from './components/Contacts.jsx';
import './App.css'; // Importera globala stilar

function App() {
  return (
    <div className="App">
      <Navbar />
      <Projects />
      <AboutMe/>
      <Contacts />
    </div>
  );
}

export default App;