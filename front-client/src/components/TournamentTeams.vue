<template>
  <div id='tournament-teams'>
    <h3>Teams in tournament {{tournament_name}}</h3>
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
  import api from '../api'
  export default {
    name: 'TournamentTeams',
    data () {
      return {
        teams: [],
        tournament_name: null
      }
    },
    mounted () {
      api.getTournament(this.$route.params.id).then(response => {
        this.teams = response.data.teams
        this.tournament_name = response.data.title
      })
    }
  }
</script>
