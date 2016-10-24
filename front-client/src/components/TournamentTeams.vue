<template>
  <div id='tournament-teams'>
    <ul v-for="team in teams">
      <li>Team: {{team.name}}</li>
      <li>
        <ul v-for="user in team.users">
          <p>Players:</p>
            <li>{{user.name}}</li>
        </ul>
      </li>
    </ul>
  </div>
</template>

<script>
  export default {
    name: 'TournamentTeams',
    props: {
      teams: Array
    }
  }
</script>
