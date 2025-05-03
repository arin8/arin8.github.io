import React from "react";
import '../styling/Projects.css';
import { projects } from "./ProjectsData";

function Projects() {
    return (
        <section id="projects" className="project-section">
                <h2>
                 Projects
                 </h2>
            <div className="card-container">
                {projects.map((project, index) =>
                (
                    <div key={index} className="card">
                        <div className="card-content">
                            <h4>
                                {project.title}
                            </h4>
                            <p>
                                {project.description}
                            </p>
                        </div>
                    </div>
                ))}
            </div>
        </section>
    );
}
export default Projects;