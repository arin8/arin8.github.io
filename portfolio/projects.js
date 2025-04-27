const projects = [
    {
        title: "Workout Diary",
        description: "A personal fitness application to design custom workouts and track progress over time.",
        link: "workout-diary.html"
    },

];

const container = document.querySelector(".card-container");

projects.forEach((project) => {
    const card = document.createElement('div');
    card.className = 'card';
    card.innerHTML = `
        <a href="${project.link}" style="text-decoration: none; color: inherit;">
            <div class="card-content">
                <h4>${project.title}</h4>
                <p>${project.description}</p>
            </div>
        </a>
  `;
  container.appendChild(card);
});