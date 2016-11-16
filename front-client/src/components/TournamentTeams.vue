<template>
  <div id='tournament-teams'>
    <p>Free slots for team: {{teams.length}} / {{tournament.teams_quantity}}</p>
    <p v-show="teams.length === 0">No teams assigned</p>
    <div v-show="teams.length < tournament.teams_quantity">
      <new-team :tournament="tournament"></new-team>
    </div>
    <ul v-for="team in teams">
      <li>
        <b>Team: {{team.name}}</b>
        <button type='button' @click='removeTeam(team.id)'>Remove team</button>
      </li>
      <li>
        <p>
          <span v-show="team.users.length < tournament.players_in_team || tournament.players_in_team === 0">
            <label for='users'>Add user</label>
            <select v-model='userToTeam[team.id]'>
              <option v-for="user in users" :value="user">
                {{ user.username }}
              </option>
            </select>
            <button type='button' @click='addUser(team.id, userToTeam[team.id])'>+</button>
          </span>
          <p v-show="tournament.players_in_team > 0">
            Free slots for users: {{tournament.players_in_team - team.users.length}}
          </p>
        </p>
      </li>
      <li>
        <ol>
          <p>Players:</p>
            <li  v-for="user in team.users">
              {{user.username}}
              <button type='button' @click='removeUser(team.id, user.id)'>Remove user</button>
            </li>
        </ol>
      </li>
    </ul>
  </div>
</template>

<script>
  import NewTeam from './NewTeam'
  export default {
    name: 'TournamentTeams',
    props: {
      tournament: {
        type: Object
      }
    },
    data () {
      return {
        userToTeam: {}
      }
    },
    computed: {
      teams () {
        return this.tournament.teams
      },
      users () {
        return this.$store.getters.users
      }
    },
    components: {
      NewTeam
    },
    methods: {
      addUser (teamId, user) {
        this.$store.dispatch('addUser', [this.tournament.id, teamId, user.id])
      },
      removeTeam (teamId) {
        this.$store.dispatch('removeTeam', [this.tournament.id, teamId])
      },
      removeUser (teamId, userId) {
        this.$store.dispatch('removeUser', [this.tournament.id, teamId, userId])
      }
    }
  }
</script>
