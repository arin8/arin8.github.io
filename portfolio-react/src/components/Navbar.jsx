import React, { useState, useEffect } from "react";
import '../styling/Navbar.css';

function Navbar() {
    const [activeSection, setActiveSection] = useState('projects');
    const [isClickScrolling, setIsClickScrolling] = useState(false);

    useEffect(() => {
        const handleScroll = () => {
            if (isClickScrolling) return;  // Stoppa scroll-lyssnaren när vi klickat

            const sections = [
                { id: 'projects', element: document.getElementById('projects') },
                { id: 'about', element: document.getElementById('about') },
                { id: 'contacts', element: document.getElementById('contacts') },
            ];

            let newActiveSection = '';

            sections.forEach(section => {
                if (section.element) {
                    const rect = section.element.getBoundingClientRect();
                    const windowHeight = window.innerHeight;

                    if (rect.top <= windowHeight / 2 && rect.bottom >= windowHeight / 2) {
                        newActiveSection = section.id;
                    }
                }
            });

            if (newActiveSection && newActiveSection !== activeSection) {
                setActiveSection(newActiveSection);
            }
        };

        window.addEventListener('scroll', handleScroll);
        return () => window.removeEventListener('scroll', handleScroll);
    }, [activeSection, isClickScrolling]);

    const handleClick = (section) => {
        setIsClickScrolling(true);
        setActiveSection(section);
        setTimeout(() => {
            setIsClickScrolling(false);
        }, 1000);  // Vänta 1 sekund innan scroll kan aktiveras igen
    };

    return (
        <nav className="navbar">
            <ul className="nav-links">
                <li>
                    <a href="#projects" onClick={() => handleClick('projects')} className={activeSection === 'projects' ? 'active' : ''}>
                        Projects
                    </a>
                </li>
                <li>
                    <a href="#about" onClick={() => handleClick('about')} className={activeSection === 'about' ? 'active' : ''}>
                        About Me
                    </a>
                </li>
                <li>
                    <a href="#contacts" onClick={() => handleClick('contacts')} className={activeSection === 'contacts' ? 'active' : ''}>
                        Contact
                    </a>
                </li>
            </ul>
        </nav>
    );
}

export default Navbar;